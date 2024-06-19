{
  config,
  pkgs,
  lib,
  colorScheme,
  ...
}: {
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
    $bg: rgba($color: #${base00}, $alpha: 0.6);
    $contrastbg: #${base00};
    $bgSecondary: #${base00};
    $bgCal: rgba($color: #${base00}, $alpha: 0.6);
    $fg: #${base06};
    $fgDim: #${base06};

    // Aliases
    $background: $bg;
    $backgroundSecondary: $bgSecondary;
    $foreground: $fg;
    $foregroundDim: $fgDim;
    $accent: #${base08};

    $yellow: #${base0A};
    $green: #${base0B};
    $cyan: #${base0C};
    $blue: #${base0D};
    $magenta: #${base0E};
    $purple: #${base0F};
    $black: #${base03};
    $red: #${base08};
  '';

  home.file.".config/eww/default_colors.json".text = with colorScheme.colors; ''
    {
      "image_accent": "#${base0D}",
      "button_accent": "#${base0D}",
      "button_text": "#${base0D}"
    }
  '';
}
