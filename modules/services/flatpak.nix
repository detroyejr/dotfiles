{
  config,
  lib,
  ...
}:
let
  cfg = config.services.flatpak;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal.enable = true;
    services.xserver.enable = true;
  };
}
