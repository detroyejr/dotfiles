{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.foot;
in
{

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      "TERMINAL" = "foot";
    };

    programs.foot.settings = {
      main = {
        font = "InputMono:size=12";
      };

      # Classic Windows 95 window gray background and dark text
      colors-dark = lib.mkIf (config.services.desktopManager.plasma6.enable) {
        background = "c0c0c0";
        foreground = "000000";

        # Normal colors (Win95 console / VGA-inspired)
        regular0 = "000000"; # black
        regular1 = "800000"; # red
        regular2 = "008000"; # green
        regular3 = "808000"; # yellow
        regular4 = "000080"; # blue (classic MS-DOS / Win95 blue background or accent)
        regular5 = "800080"; # magenta
        regular6 = "008080"; # cyan
        regular7 = "c0c0c0"; # white (light gray)

        # Bright colors
        bright0 = "808080"; # bright black (gray)
        bright1 = "ff0000"; # bright red
        bright2 = "00ff00"; # bright green
        bright3 = "ffff00"; # bright yellow
        bright4 = "0000ff"; # bright blue
        bright5 = "ff00ff"; # bright magenta
        bright6 = "00ffff"; # bright cyan
        bright7 = "ffffff"; # bright white
      };
    };
  };
}
