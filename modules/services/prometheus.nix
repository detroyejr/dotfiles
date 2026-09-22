{
  lib,
  config,
  ...
}:
let
  cfg = config.services.prometheus;
  port = 9100;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.prometheus.remoteWrite = [
      {
        name = config.networking.hostName;
        url = "http://odp-2:9091/api/v1/write";
      }
    ];

    services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    services.prometheus.retentionTime = "365d";
  };
}
