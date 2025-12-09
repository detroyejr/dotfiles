{
  pkgs,
  config,
  ...
}:

let
  text_color = "rgba(${config.colorScheme.colors.base04}FF)";
  entry_background_color = "rgba(${config.colorScheme.colors.base02}FF)";
  entry_border_color = "rgba(${config.colorScheme.colors.base09}FF)";
  hyprlockConfig = pkgs.writeText "hyprlock.conf" ''
    background {
      monitor=
      blur_passes=1
      blur_size=7
      path=${config.colorScheme.wallpaper}
    }

    image {
      monitor=
      size=400
      halign=center
      path=${config.colorScheme.profile}
      position=0, 270
      rounding=-1
      valign=center
    }

    input-field {
      monitor=
      size=350, 90
      dots_size=0.300000
      dots_spacing=0.400000
      font_color=rgba(${text_color})
      halign=center
      inner_color=rgba(${entry_background_color})
      outer_color=rgba(${entry_border_color})
      outline_thickness=2
      position=0, -130
      valign=center
    }

    label {
      monitor=
      color=rgba(${text_color})
      font_family=${config.font.name}
      font_size=65
      halign=center
      position=0, 550
      rotate=0
      text=$TIME
      text_align=center
      valign=center
    }

    label {
      monitor=
      color=rgba(${text_color})
      font_family=${config.font.name}
      font_size=35
      halign=center
      position=0, 0
      rotate=0
      text=Hi there, $USER
      text_align=center
      valign=center
    }
  '';
in
{
  programs.hyprlock.enable = config.programs.hyprland.enable;
  environment.etc = {
    "xdg/hypr/hyprlock.conf".source = hyprlockConfig;
  };
}
