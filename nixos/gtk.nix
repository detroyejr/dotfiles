{
  pkgs,
  config,
  lib,
  ...
}:

let

  repo = builtins.fetchGit {
    url = "https://github.com/Misterio77/nix-colors";
    rev = "37227f274b34a3b51649166deb94ce7fec2c6a4c";
  };
  nix-colors-lib = {
    gtkThemeFromScheme = import "${repo}/lib/contrib/gtk-theme.nix" { inherit pkgs; };
  };
  gtkTheme = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
in
{
  users.users.detroyejr.packages = [
    gtkTheme
    config.cursor.package
  ];

  environment.sessionVariables = {
    CURSOR_THEME = config.cursor.name;
    GDK_BACKEND = "wayland";
    GTK_THEME = config.colorScheme.slug;
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
          gtk-theme = "${config.colorScheme.slug}";
          monospace-font-name = "${config.font.name} ${config.font.size}";
          text-scaling-factor = lib.gvariant.mkDouble config.font.scale;
        };
      };
    }
  ];
}
