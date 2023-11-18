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
      # Based on https://github.com/kdrag0n/base16-kitty/
      active_border_color = "#${base03}";
      active_tab_background = "#${base00}";
      active_tab_foreground = "#${base05}";
      background = "#${base00}";
      cursor = "#${base05}";
      foreground = "#${base05}";
      inactive_border_color = "#${base01}";
      inactive_tab_background = "#${base01}";
      inactive_tab_foreground = "#${base04}";
      selection_background = "#${base05}";
      selection_foreground = "#${base00}";
      tab_bar_background = "#${base01}";
      url_color = "#${base04}";

      color0 = "#${base00}";
      color1 = "#${base08}";
      color2 = "#${base0B}";
      color3 = "#${base0A}";
      color4 = "#${base0D}";
      color5 = "#${base0E}";
      color6 = "#${base0C}";
      color7 = "#${base05}";
      color8 = "#${base03}";
      color9 = "#${base09}";
      color10 = "#${base0B}";
      color11 = "#${base0F}";
      color12 = "#${base0D}";
      color13 = "#${base0E}";
      color14 = "#${base0F}";
      color15 = "#${base07}";
    };
  };
}
