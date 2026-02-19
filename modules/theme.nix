{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (import ./utils.nix) mkTheme nextWallpaper;
  themeNames = {
    wall-etna = "rose-pine";
    wall-blue-mountain = "nord";
  };

  schemes = {
    rose-pine = {
      slug = "rose-pine";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "191724";
        base01 = "1f1d2e";
        base02 = "26233a";
        base03 = "6e6a86";
        base04 = "908caa";
        base05 = "e0def4";
        base06 = "e0def4";
        base07 = "524f67";
        base08 = "eb6f92";
        base09 = "f6c177";
        base0A = "ebbcba";
        base0B = "31748f";
        base0C = "9ccfd8";
        base0D = "c4a7e7";
        base0E = "f6c177";
        base0F = "524f67";
      };
    };

    nord = {
      slug = "nord";
      colors = rec {
        background = base00;
        foreground = base06;
        base00 = "2E3440";
        base01 = "3B4252";
        base02 = "434C5E";
        base03 = "4C566A";
        base04 = "D8DEE9";
        base05 = "E5E9F0";
        base06 = "ECEFF4";
        base07 = "8FBCBB";
        base08 = "BF616A";
        base09 = "D08770";
        base0A = "EBCB8B";
        base0B = "A3BE8C";
        base0C = "88C0D0";
        base0D = "81A1C1";
        base0E = "B48EAD";
        base0F = "5E81AC";
      };
    };
  };
in
{
  imports = [
    ./gtk.nix
    ./hyprlock.nix
    ./rofi.nix
    ./wallpaper.nix
    ./wezterm.nix
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
      default = map (wall: mkTheme wall schemes.${themeNames.${wall.name}} config.font) config.walls;
      type = lib.types.listOf lib.types.package;
      description = "List of wallpaper derivations with resized variants.";
    };
  };

  config = lib.mkIf config.programs.hyprland.enable {
    xdg.portal.config.common.default = "*";

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    programs.hyprland.xwayland.enable = true;
    programs.waybar.enable = true;

    programs.chromium.enable = true;

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-hyperion
      ];
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
      BROWSER = "firefox";
    };

    users.users.${config.defaultUser}.packages =
      (with pkgs; [
        acpi
        alsa-utils
        anki
        blueman
        bluez
        brightnessctl
        calibre
        chromium
        colorz
        discord
        dmenu
        easyeffects
        element-desktop
        grim
        hyperion-ng
        hyprpaper
        hyprpicker
        kanshi
        keepass
        libnotify
        libreoffice
        lutris
        mako
        mp4v2
        networkmanager_dmenu
        nfs-utils
        obsidian
        pamixer
        pavucontrol
        playerctl
        plex-desktop
        plex-htpc
        plexamp
        procps
        slack
        slurp
        socat
        vlc
        wireplumber
        wlr-randr
        wlsunset
        wofi-emoji
        wpgtk
        xdo
        xdotool
      ])
      ++ [ nextWallpaper ];

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

        for path in wezterm waybar hypr; do
          if [ -d "/etc/xdg/$path" ]; then
            unlink "/etc/xdg/$path"
          fi;
          ln -s "$currentTheme/$path" "/etc/xdg/$path"
        done;
      '';
    };
  };
}
