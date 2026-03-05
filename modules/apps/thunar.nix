{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.thunar;
in
{
  config = lib.mkIf cfg.enable {
    programs.thunar.plugins = with pkgs; [ xfce4-exo ];

    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };
  };
}
