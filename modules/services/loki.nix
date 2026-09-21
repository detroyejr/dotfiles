{ config, lib, ... }:
let
  cfg = config.services.loki;
  dataDir = "/var/lib/loki";
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 3100 ];

    services.loki = {
      dataDir = dataDir;
      configuration = {
        auth_enabled = false;

        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 3100;
          grpc_listen_port = 9096;
        };

        common = {
          path_prefix = dataDir;
          storage.filesystem = {
            chunks_directory = "${dataDir}/chunks";
            rules_directory = "${dataDir}/rules";
          };
          replication_factor = 1;
          ring.kvstore.store = "inmemory";
        };

        schema_config.configs = [
          {
            from = "2024-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        analytics.reporting_enabled = false;
      };
    };
  };
}
