{ config, ... }:
{
  environment.sessionVariables = {
    XCURSOR_SIZE = config.cursor.size;
    XCURSOR_THEME = config.cursor.name;
    XDG_CONFIG_HOME = "/etc/xdg";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_CURSOR_THEME = config.cursor.name;
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  xdg.icons.fallbackCursorThemes = [ config.cursor.name ];

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
