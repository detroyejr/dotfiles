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

    environment.etc."grafana-dashboards/odp-build-cluster.json".source =
      ./grafana-dashboards/odp-build-cluster.json;

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

        alerting.rules.settings = {
          apiVersion = 1;
          groups = [
            {
              orgId = 1;
              name = "ODP";
              folder = "ODP";
              interval = "1m";
              rules = [
                {
                  uid = "ag2w7f0okslj4a";
                  title = "Low Storage Alert";
                  condition = "C";
                  data = [
                    {
                      refId = "A";
                      relativeTimeRange = {
                        from = 600;
                        to = 0;
                      };
                      datasourceUid = "odp";
                      model = {
                        editorMode = "code";
                        expr = "100 * (1 - max by (instance) (node_filesystem_avail_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"}))";
                        instant = true;
                        intervalMs = 1000;
                        legendFormat = "__auto";
                        maxDataPoints = 43200;
                        range = false;
                        refId = "A";
                      };
                    }
                    {
                      refId = "C";
                      queryType = "expression";
                      datasourceUid = "__expr__";
                      model = {
                        conditions = [
                          {
                            evaluator = {
                              params = [ 98 ];
                              type = "gt";
                            };
                            operator.type = "and";
                            query.params = [ "C" ];
                            reducer = {
                              params = [ ];
                              type = "last";
                            };
                            type = "query";
                          }
                        ];
                        datasource = {
                          type = "__expr__";
                          uid = "__expr__";
                        };
                        expression = "A";
                        intervalMs = 1000;
                        maxDataPoints = 43200;
                        refId = "C";
                        type = "threshold";
                      };
                    }
                  ];
                  noDataState = "OK";
                  execErrState = "Error";
                  "for" = "5m";
                  annotations.summary = "Low storage alert.";
                  labels = { };
                  isPaused = false;
                  notification_settings.receiver = "Pushover";
                }
              ];
            }
          ];
        };
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
            uid = "odp";
            orgId = 1;
            url = "http://odp-2:9090";
            basicAuth = false;
            editable = false;
          }
          {
            name = "ODP Logs";
            type = "loki";
            uid = "odp-logs";
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
