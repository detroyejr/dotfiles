{config, pkgs, nix-colors, colorSchemeName, colorScheme, ...}:
let
  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in {
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu-R 12";
    };
    theme = {
      name = colorSchemeName;
      package = nix-colors-lib.gtkThemeFromScheme {
        scheme = colorScheme;
      };
    };
  };
}
