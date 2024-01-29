{ config, pkgs, colorScheme, ... }:
{


  home.packages = with pkgs; [
    rofi
    rofi-power-menu
  ];

  home.file.".config/rofi".source = pkgs.fetchFromGitHub
    {
      owner = "adi1090x";
      repo = "rofi";
      rev = "master";
      sha256 = "sha256-YjyrxappcLDoh3++mtZqCyxQV2qeoNhhUy2XGwlyTng=";
    } + "/files";

  home.file.".local/usr/bin/rofi-launch".text = ''
    dir="$HOME/.config/rofi/launchers/type-7"
    theme='style-2'

    ## Run
    rofi \
      -show drun \
      -theme ''${dir}/''${theme}.rasi
  '';
}
