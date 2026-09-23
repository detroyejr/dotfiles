{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.grafana;
in
{
  config = lib.mkIf cfg.enable {

    environment.etc."grafana-dashboards/node-exporter-full.json".source = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/1860/revisions/latest/download";
      hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
    };

    sops.secrets = {
      "grafana/secret_key" = {
        owner = "detroyejr";
        group = "detroyejr";
      };
    };

    networking.firewall.allowedTCPPorts = [ 3001 ];

    services.grafana = {
      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            name = "default";
            options.path = "/etc/grafana-dashboards";
          }
        ];
      };

      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3001;
        };
        security = {
          secret_key = config.sops.secrets."grafana/secret_key".path;
        };
      };

      provision.datasources.settings = {
        datasources = [
          {
            name = "ODP";
            type = "prometheus";
            orgId = 1;
            url = "http://odp-2:9090";
            basicAuth = false;
            editable = false;
          }
          {
            name = "ODP Logs";
            type = "loki";
            orgId = 1;
            url = "http://odp-2:3100";
            basicAuth = false;
            editable = false;
          }
        ];

        deleteDatasources = [
          {
            name = "ODP";
            orgId = 1;
          }
          {
            name = "ODP Logs";
            orgId = 1;
          }
        ];
      };
    };
  };
}
