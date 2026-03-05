{
  config,
  lib,
  ...
}:
let
  cfg = config.services.openrgb;
in
{
  options.services.openrgb.enable = lib.mkEnableOption "OpenRGB service module";

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb.enable = true;
  };
}
