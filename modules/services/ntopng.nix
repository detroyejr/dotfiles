{
  config,
  lib,
  ...
}:
let
  cfg = config.services.ntopng;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.httpPort ];

    services.ntopng = {
      interfaces = [ "any" ];
      httpPort = 3000;
    };
  };
}
