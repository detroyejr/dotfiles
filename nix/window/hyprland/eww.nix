{ config, pkgs, lib, colorScheme, ... }:
{
  home.file = {
    ".config/eww/bar".source = ../../../dotfiles/eww/bar;
    ".config/eww/actions".source = ../../../dotfiles/eww/actions;
    ".config/eww/definitions".source = ../../../dotfiles/eww/definitions;
    ".config/eww/scripts".source = ../../../dotfiles/eww/scripts;
  };


  home.file.".config/eww/eww.yuck".text = ''
    (include "./definitions/_variables.yuck")
    (include "./bar/bar.yuck")
    (include "actions/actions.yuck")
  '';

  home.file.".config/eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "BlexMono Nerd Font Mono, monospace";
    }

    @import "colors.scss";
    @import "bar/bar.scss";
    @import "actions/actions.scss";
  '';

  home.file.".config/eww/colors.scss".text = with colorScheme.colors; ''
    $bg: rgba($color: #${color0}, $alpha: 0.6);
    $contrastbg: #${color0};
    $bgSecondary: #${color0};
    $bgCal: rgba($color: #${color0}, $alpha: 0.6);
    $fg: #${color7};
    $fgDim: #${color7};

    // Aliases
    $background: $bg;
    $backgroundSecondary: $bgSecondary;
    $foreground: $fg;
    $foregroundDim: $fgDim;
    $accent: #${color1};

    $yellow: #${color3};
    $green: #${color2};
    $cyan: #${color4};
    $blue: #${color12};
    $magenta: #${color14};
    $purple: #${color5};
    $black: #${color0};
    $red: #${color1};
  '';

  home.file.".config/eww/default_colors.json".text = with colorScheme.colors; ''
    { 
      "image_accent": "#${color1}",
      "button_accent": "#${color1}",
      "button_text": "#${color1}",
    }
  '';
}


