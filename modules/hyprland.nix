{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.hyprland;
  utils = import ./utils.nix { inherit pkgs lib; };
  inherit (utils)
    themeNames
    schemes
    mkNextWallpaper
    mkSetTheme
    mkRofiThemeSelector
    mkTheme
    ;
in
{
  imports = [
    ./gtk.nix
    ./hyprlock.nix
    ./rofi.nix
    ./wallpaper.nix
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
    themes = lib.mkOption {
      default = map (
        wall: mkTheme config wall schemes.${themeNames.${wall.name}} config.font
      ) config.walls;
      type = lib.types.listOf lib.types.package;
      description = "List of wallpaper derivations with resized variants.";
    };
  };

  config = lib.mkIf cfg.enable {

    xdg.portal = {
      config.common.default = "*";
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    programs = {
      hyprland.xwayland.enable = true;
      waybar.enable = true;
    };

    services = {
      displayManager = {
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

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };

    users.users.${config.defaultUser}.packages = with pkgs; [
      (mkNextWallpaper config)
      (mkSetTheme config)
      (mkRofiThemeSelector config)
      acpi
      alsa-utils
      blueman
      bluez
      brightnessctl
      colorz
      dmenu
      easyeffects
      grim
      hyprpaper
      hyprpicker
      kanshi
      keepass
      libnotify
      mako
      mp4v2
      networkmanager_dmenu
      nfs-utils
      pamixer
      pavucontrol
      playerctl
      procps
      slurp
      socat
      wireplumber
      wlr-randr
      wlsunset
      wofi-emoji
      wpgtk
      xdo
      xdotool
    ];

    system.activationScripts = {
      setTheme = ''
        #!/usr/bin/env bash

        # Collect paths into an array.
        export themePaths=(${lib.concatStringsSep " " config.themes})
        export themeName=(${lib.concatStringsSep " " (lib.attrNames themeNames)})
        export index=''$((RANDOM % ''${#themePaths[@]}))
        currentTheme="''${themePaths[''$index]}"
        if [ -d /etc/xdg/CURRENT_THEME ]; then
          unlink /etc/xdg/CURRENT_THEME
        fi;
        ln -s $currentTheme /etc/xdg/CURRENT_THEME

        for path in wezterm waybar hypr mako; do
          if [ -d "/etc/xdg/$path" ]; then
            unlink "/etc/xdg/$path"
          fi;
          ln -s "$currentTheme/$path" "/etc/xdg/$path"
        done;
      '';
    };
  };
}
