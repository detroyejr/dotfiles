{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.kde;
  windows95StartupSound = pkgs.fetchurl {
    url = "https://archive.org/download/windows95_startup_hifi/windows95_startup_hifi.wav";
    hash = "sha256-qdAqPmtD+P0iQdXA7DH1extTsM+O5iHPTq//RnKQ9yc=";
  };
in
{
  options.programs.kde.enable = lib.mkEnableOption "KDE Plasma desktop";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
      xserver.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.sessionVariables = {
      XDG_CONFIG_HOME = "/etc/xdg";
    };

    # Set Firefox as default browser
    xdg.mime = {
      enable = true;
      defaultApplications = lib.mkIf config.programs.firefox.enable {
        "text/html" = "firefox.desktop";
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
      XDG_VIDEOS_DIR="$HOME/Videos"
    '';

    environment.etc."xdg/autostart/windows95-startup-sound.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Windows 95 Startup Sound
      Comment=Play the Windows 95 startup sound when KDE starts
      Exec=${pkgs.pipewire}/bin/pw-play ${windows95StartupSound}
      Terminal=false
    '';

    environment.systemPackages = with pkgs; [
      windows95-kde-theme
    ];
  };
}
