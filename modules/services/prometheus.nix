{
  lib,
  config,
  ...
}:
let
  cfg = config.services.prometheus;
  port = 9090;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.prometheus.listenAddress = "0.0.0.0";
    services.prometheus.remoteWrite = lib.mkIf (config.networking.hostName != "odp-2") [
      {
        name = config.networking.hostName;
        url = "http://odp-2:9090/api/v1/write";
      }
    ];

    services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    services.prometheus.retentionTime = "365d";
  };
}
