{config, pkgs, nix-colors, colorSchemeName, colorScheme, ...}:
let
  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
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
      name = "Ubuntu 12";
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
