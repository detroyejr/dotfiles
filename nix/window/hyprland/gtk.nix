{
  config,
  pkgs,
  nix-colors,
  colorSchemeName,
  colorScheme,
  ...
}: let
  repo = builtins.fetchGit {
    url = "https://github.com/Misterio77/nix-colors";
    rev = "37227f274b34a3b51649166deb94ce7fec2c6a4c";
  };
  nix-colors-lib = {
    gtkThemeFromScheme = import "${repo}/lib/contrib/gtk-theme.nix" {inherit pkgs;};
  };
in {
  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    gtk.enable = true;
    x11.enable = true;
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = "BlexMono Nerd Font Mono, monospace 12";
    };
    theme = {
      name = colorSchemeName;
      package = nix-colors-lib.gtkThemeFromScheme {
        scheme = colorScheme;
      };
    };
    cursorTheme = {
      name = "Numix-Cursor";
      size = 24;
      package = pkgs.numix-cursor-theme;
    };
  };
}
