{ config, lib, ... }:
let
  cfg = config.services.paperless;
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets."paperless/password" = {
      owner = "detroyejr";
      group = "detroyejr";
    };

    services.paperless = {
      address = "0.0.0.0";
      user = "detroyejr";
      passwordFile = config.sops.secrets."paperless/password".path;
    };

    users.users.${config.defaultUser}.extraGroups = [
      config.services.redis.servers.paperless.group
    ];

    networking.firewall.allowedTCPPorts = [ config.services.paperless.port ];
  };
}
