{ config, pkgs, lib, fetchFromGitHub, ... }:
{
  imports = [
    ./gtk.nix
    ./rofi.nix
    ./eww.nix
  ];

  home.sessionVariables = {
    XCURSOR_SIZE = 12;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "2";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "2";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = "1";
  };

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

  home.file.".config/hypr" = {
    source = ../../../dotfiles/hypr;
    recursive = true;
  };
}
