{ config, pkgs, colorScheme, ... }:
{

  programs.kitty = {
    enable = true;
    font = {
      name= "BlexMono Nerd Font Mono";
      size = 14;
    };
    settings = with colorScheme.colors; {
      bold_font = "auto";
      disable_liagures = "never";
      enable_audio_bell = false;
      cursor_shape = "beam";
      # Based on https://github.com/kdrag0n/base16-kitty/
      active_border_color = "#${color0}";
      active_tab_background = "#${color0}";
      active_tab_foreground = "#${color8}";
      background = "#${color0}";
      cursor = "#${color7}";
      foreground = "#${color7}";
      inactive_border_color = "#${color8}";
      inactive_tab_background = "#${color8}";
      inactive_tab_foreground = "#${color4}";
      selection_background = "#${color8}";
      selection_foreground = "#${color0}";
      tab_bar_background = "#${color8}";
      url_color = "#${color4}";

      color0 = "#${color0}";
      color1 = "#${color1}";
      color2 = "#${color2}";
      color3 = "#${color3}";
      color4 = "#${color4}";
      color5 = "#${color5}";
      color6 = "#${color6}";
      color7 = "#${color7}";
      color8 = "#${color8}";
      color9 = "#${color9}";
      color10 = "#${color10}";
      color11 = "#${color11}";
      color12 = "#${color12}";
      color13 = "#${color13}";
      color14 = "#${color14}";
      color15 = "#${color15}";
    };
  };
}
