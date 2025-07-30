{ config, ... }:
{
  environment.sessionVariables = {
    XCURSOR_SIZE = config.cursor.size;
    XCURSOR_THEME = config.cursor.name;
    XDG_CONFIG_HOME = "/etc/xdg";
    XDG_CURSOR_THEME = config.cursor.name;
  };

  xdg.icons.fallbackCursorThemes = [ config.cursor.name ];

  # Set Firefox as default browser
  xdg.mime = {
    enable = true;
    defaultApplications = {
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
}
