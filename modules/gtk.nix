{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = [
      # gtkTheme
      config.cursor.package
    ];

    environment.sessionVariables = {
      CURSOR_THEME = config.cursor.name;
      GDK_BACKEND = "wayland";
      QT_AUTO_SCALE_SCREEN_FACTOR = "1";
      XCURSOR_THEME = config.cursor.name;
      XCURSOR_SIZE = config.cursor.size;
      XDG_CURSOR_THEME = config.cursor.name;
    };

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            clock-format = "12h";
            color-scheme = "prefer-dark";
            cursor-size = lib.gvariant.mkInt32 config.cursor.size;
            cursor-theme = config.cursor.name;
            document-font-name = "${config.font.name} ${config.font.size}";
            font-name = "${config.font.name} ${config.font.size}";
            monospace-font-name = "${config.font.name} ${config.font.size}";
            text-scaling-factor = lib.gvariant.mkDouble config.font.scale;
          };
        };
      }
    ];
  };
}
