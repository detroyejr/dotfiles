{ config, lib, ... }:
let
  cfg = config.programs.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
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

    environment.etc = {
      "xdg/user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/Desktop"
        XDG_DOCUMENTS_DIR="$HOME/Documents"
        XDG_DOWNLOAD_DIR="$HOME/Downloads"
        XDG_MUSIC_DIR="$HOME/Music"
        XDG_PICTURES_DIR="$HOME/Documents/Pictures"
        XDG_PUBLICSHARE_DIR="$HOME/Public"
        XDG_TEMPLATES_DIR="$HOME/Templates"
        XDG_VIDEOS_DIR="$HOME/Documents/Videos"
      '';
    };
  };
}
