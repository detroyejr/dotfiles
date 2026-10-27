{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.alloy;
in
{
  config = lib.mkIf cfg.enable {
    services.alloy.package = pkgs.grafana-alloy.override {
      systemdLibs = pkgs.systemdLibs.override { withCompression = true; };
    };

    environment.etc."alloy/config.alloy".text = ''
      prometheus.exporter.unix "local_system" { }

      discovery.relabel "local_system" {
        targets = prometheus.exporter.unix.local_system.targets

        rule {
          target_label = "host"
          replacement  = "${config.networking.hostName}"
        }

        rule {
          target_label = "instance"
          replacement  = "${config.networking.hostName}"
        }
      }

      prometheus.scrape "scrape_metrics" {
        targets         = discovery.relabel.local_system.output
        forward_to      = [prometheus.remote_write.metrics_service.receiver]
        scrape_interval = "10s"
      }

      prometheus.remote_write "metrics_service" {
        endpoint {
            url = "http://odp-2:9090/api/v1/write"
        }
      }

      loki.write "grafana_loki" {
        endpoint {
          url = "http://odp-2:3100/loki/api/v1/push"
        }
      }

      loki.source.journal "logs_integrations_integrations_node_exporter_journal_scrape" {
        max_age = "24h0m0s"
        labels        = {host = "${config.networking.hostName}"}
        relabel_rules = discovery.relabel.logs_integrations_integrations_node_exporter_journal_scrape.rules
        forward_to    = [loki.write.grafana_loki.receiver]
      }

      discovery.relabel "logs_integrations_integrations_node_exporter_journal_scrape" {
        targets = []

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }

        rule {
          source_labels = ["__journal__boot_id"]
          target_label  = "boot_id"
        }

        rule {
          source_labels = ["__journal__transport"]
          target_label  = "transport"
        }

        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "level"
        }
      }
    '';
  };
}
