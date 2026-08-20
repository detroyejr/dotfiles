{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.immich;
in
{
  config = lib.mkIf cfg.enable {
    services.immich = {
      openFirewall = true;
      host = "0.0.0.0";
    };
    services.postgresql = {
      package = pkgs.postgresql_18;
    };
  };
}
