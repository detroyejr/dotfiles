{ config, pkgs, nix-colors, colorSchemeName, colorScheme, ... }:
let
  repo = builtins.fetchGit {
    url = "https://github.com/Misterio77/nix-colors";
    rev = "37227f274b34a3b51649166deb94ce7fec2c6a4c";
  };
  nix-colors-lib = {
    gtkThemeFromScheme = import "${repo}/lib/contrib/gtk-theme.nix" { inherit pkgs; };
  };

  gtkColorScheme = pkgs.lib.recursiveUpdate colorScheme {
    colors = {
      base00 = colorScheme.colors.color0;
      base01 = colorScheme.colors.color8;
      base02 = colorScheme.colors.color8;
      base03 = colorScheme.colors.color8;
      base04 = colorScheme.colors.color4;
      base05 = colorScheme.colors.color7;
      base06 = colorScheme.colors.color15;
      base07 = colorScheme.colors.color15;
      base08 = colorScheme.colors.color2;
      base09 = colorScheme.colors.color11;
      base0A = colorScheme.colors.color11;
      base0B = colorScheme.colors.color3;
      base0C = colorScheme.colors.color6;
      base0D = colorScheme.colors.color4;
      base0E = colorScheme.colors.color5;
      base0F = colorScheme.colors.color13;
    };
  };
in
{


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
        scheme = gtkColorScheme;
      };
    };
    cursorTheme = {
      name = "Numix-Cursor";
      size = 24;
      package = pkgs.numix-cursor-theme;
    };
  };
}
