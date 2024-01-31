{ config, pkgs, colorScheme, wallpaper, ... }:
let
  rofi-themes = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    sha256 = "sha256-YjyrxappcLDoh3++mtZqCyxQV2qeoNhhUy2XGwlyTng=";
  };
  paths = [
    "applets"
    "colors"
    "config.rasi"
    "applets"
    "config.rasi"
    "launchers"
    "scripts"
    "colors"
    "powermenu"
  ];
  originalRofiThemes = pkgs.lib.listToAttrs (map (e: pkgs.lib.nameValuePair ".config/rofi/${e}" { source = rofi-themes + "/files/" + e; }) paths);
  customRofiTweaks = {
    ".config/rofi/images/c.png".source = builtins.path { path = wallpaper; };
    ".local/bin/rofi-launcher" = {
      text = ''
        dir="$HOME/.config/rofi/launchers/type-7"
        theme='style-3'

        ## Run
        rofi \
          -show drun \
          -theme ''${dir}/''${theme}.rasi
      '';
      executable = true;
    };
  };
  patchedRofiTheme = originalRofiThemes // customRofiTweaks;
in
{

  home.packages = with pkgs; [
    rofi
    rofi-power-menu
  ];

  home.file = patchedRofiTheme;
}
