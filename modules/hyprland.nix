{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.hyprland;
  inherit (import ./utils.nix { inherit pkgs lib; }) mkHyprlandConfig;
in
{
  imports = [
    ./gtk.nix
    ./omarchy-quickshell.nix
  ];

  options = {
    font = lib.mkOption {
      default = {
        name = "Input Mono";
        size = "11";
        scale = "1";
      };
      type = lib.types.attrs;
      description = "Font settings used across the UI (name, size, scale).";
    };
    cursor = lib.mkOption {
      default = {
        name = "Bibata-Modern-Ice";
        size = "14";
        package = pkgs.bibata-cursors;
      };
      type = lib.types.attrs;
      description = "Cursor theme settings (cursor name, size and package).";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.etc."xdg/hypr/hyprland.lua".source = mkHyprlandConfig config;
    environment.sessionVariables.OMARCHY_PATH = "/etc/omarchy";

    xdg.portal = {
      config.common.default = "*";
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    programs = {
      hyprland = {
        withUWSM = true;
        xwayland.enable = true;
      };
      uwsm.enable = true;
      nautilus.enable = true;
      omarchy-quickshell.enable = true;
    };

    services = {
      displayManager = {
        defaultSession = "hyprland-uwsm";
        gdm.enable = true;
        autoLogin = {
          enable = true;
          user = config.defaultUser;
        };
      };
      xserver.enable = true;
      upower = {
        enable = true;
        usePercentageForPolicy = true;
      };
    };

    users.users.${config.defaultUser}.packages = with pkgs; [
      acpi
      alsa-utils
      bluez
      brightnessctl
      colorz
      dmenu
      easyeffects
      grim
      inputs.hokum.packages.${system}.default # replaces mako
      hyprpicker
      hyprsunset
      inotify-tools
      keepass
      libnotify
      # mako
      mp4v2
      newsboat
      nfs-utils
      pamixer
      pavucontrol
      playerctl
      procps
      wireplumber
      wlr-randr
      wlsunset
      wofi-emoji
    ];
  };
}
