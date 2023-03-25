{ config, pkgs, lib, dotfiles, fetchFromGitHub, ... }:
{
  home.packages = with pkgs; [
    acpi
    bash
    bc
    blueberry
    bluez
    brightnessctl
    coreutils
    dbus
    dunst
    dunst
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    gojq
    grim
    hyprpaper
    imagemagick
    jaq
    light
    material-icons
    networkmanager
    pamixer
    pavucontrol
    pipewire
    playerctl
    procps
    pulseaudio
    ripgrep
    slurp
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wl-clipboard
    wlogout
    wlsunset
    xdg-desktop-portal-wlr
  ];

  programs.rofi.enable = true;
 
  home.file.".config/rofi" = {
    source = ../dotfiles/rofi;
    recursive = true;
  };
  
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../dotfiles/eww;
  };

  home.file.".config/hypr" = {
    source = ../dotfiles/hypr;
    recursive = true;
  };
  
}
