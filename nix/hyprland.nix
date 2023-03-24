{ config, pkgs, lib, fetchFromGitHub, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
  
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
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
  ];

  programs.rofi.enable = true;
 
  home.file."/home/detroyejr/.config/rofi" = {
    source = ../assets/.config/rofi;
    recursive = true;
  };
  
  # programs.waybar = {
  #   enable = true;
  #   package = pkgs.waybar;
  # };
  #
  # home.file."/home/detroyejr/.config/waybar" = {
  #   source = ../assets/.config/waybar;
  #   recursive = true;
  # };

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
