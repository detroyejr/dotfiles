{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = with pkgs; [
      rofi
      rofi-power-menu
    ];
  };
}
