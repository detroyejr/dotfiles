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
    environment.sessionVariables = {
      OMARCHY_PATH = "/etc/omarchy";
      XDG_CONFIG_HOME = "/etc/xdg";
    };

    xdg.icons.fallbackCursorThemes = [ config.cursor.name ];

    # Set Firefox as default browser
    xdg.mime = {
      enable = true;
      defaultApplications = lib.mkIf config.programs.firefox.enable {
        "text/html" = "firefox.desktop";
        "text/pdf" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    environment.etc."xdg/user-dirs.dirs".text = ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Documents/Sync/Pictures"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_TEMPLATES_DIR="$HOME/Templates"
      XDG_VIDEOS_DIR="$HOME/Documents/Videos"
    '';

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
      nautilus.enable = false;
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
      carrier
      colorz
      dmenu
      easyeffects
      flea
      grim
      hyprpicker
      hyprsunset
      imv
      inotify-tools
      inputs.hokum.packages.${system}.default # replaces mako
      keepass
      libnotify
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
