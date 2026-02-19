{ config, ... }:
{

  sops.secrets = {
    "grafana/secret_key" = {
      owner = "detroyejr";
      group = "detroyejr";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3001 ];

  services.grafana = {
    enable = true;
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
      ];

      deleteDatasources = [
        {
          name = "ODP";
          orgId = 1;
        }
      ];
    };
  };

}
