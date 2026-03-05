{ config, lib, ... }:
let
  cfg = config.services.actual;
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets."actual/cert" = {
      owner = "actual";
      group = "actual";
    };

    sops.secrets."actual/key" = {
      owner = "actual";
      group = "actual";
    };

    users = {
      groups.actual = { };
      users = {
        actual = {
          group = "actual";
          isSystemUser = true;
        };
      };
    };

    services.actual.settings.https = {
      cert = config.sops.secrets."actual/cert".path;
      key = config.sops.secrets."actual/key".path;
    };

    networking.firewall.allowedTCPPorts = [
      3000
    ];
  };
}
