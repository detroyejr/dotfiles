{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.veikk;
in
{
  options.services.veikk.enable = lib.mkEnableOption "veikk service module";

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.veikkDriver ];
    environment.systemPackages = [ pkgs.veikk ];
  };
}
