{ config, pkgs, lib, fetchFromGitHub, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
  
  home.packages = with pkgs; [
    socat
    grim
    slurp
    wlsunset
    brightnessctl
    dunst
    hyprpaper
    pamixer
    pavucontrol
    wl-clipboard
  ];

  programs.rofi.enable = true;
 
  home.file."/home/detroyejr/.config/rofi" = {
    source = ../assets/.config/rofi;
    recursive = true;
  };
  
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  home.file."/home/detroyejr/.config/waybar" = {
    source = ../assets/.config/waybar;
    recursive = true;
  };

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../assets/.config/eww;
  };

  home.file."/home/detroyejr/.config/hypr" = {
    source = ../assets/.config/hypr;
    recursive = true;
  };
  
  home.file."/home/detroyejr/.config/ranger" = {
    source = ../assets/.config/ranger;
    recursive = true;
  };
}
