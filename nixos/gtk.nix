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
    pkgs.bibata-cursors
  ];

  environment.sessionVariables = {
    CURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    GDK_BACKEND = "wayland";
    GTK_THEME = config.colorScheme.slug;
    QT_AUTO_SCALE_SCREEN_FACTOR = "1";
    XDG_CONFIG_HOME = "/etc/xdg";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  qt.enable = true;
  qt.style = "gtk2";

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          clock-format = "12h";
          color-scheme = "prefer-dark";
          cursor-size = lib.gvariant.mkInt32 11;
          cursor-theme = "Bibata-Modern-Ice";
          document-font-name = "Input Mono 11";
          font-name = "Input Mono 11";
          gtk-theme = "${config.colorScheme.slug}";
          monospace-font-name = "Input Mono 11";
          text-scaling-factor = lib.gvariant.mkDouble 1.0;
        };
      };
    }
  ];
}
