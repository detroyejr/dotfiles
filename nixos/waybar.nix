{ pkgs, config, ... }:
let
  waybarConfigStyle = pkgs.writeText "config.css" ''
    @define-color accent #${config.colorScheme.colors.base08};
  '';
in
{
  programs.waybar.enable = config.programs.hyprland.enable;
  environment.etc = {
    "xdg/waybar/config".source = ../dotfiles/waybar/config;
    "xdg/waybar/style.css".source = ../dotfiles/waybar/style.css;
    "xdg/waybar/config.css".source = waybarConfigStyle;
  };
}
