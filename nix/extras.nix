{ config, pkgs, fetchFromGitHub, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    kitty
  ];
  
  home.file."/home/detroyejr/.config/kitty/kitty.conf".text = "
    include ./Tokyo Night Day.conf
    font_family CaskaydiaCove NF Mono
    bold_font auto
    italic_font auto
    bold_italic_font auto
    font_size 19.0
    disable_ligatures never
    initial_window_width 640 
    initial_window_height 100
  ";
  
  home.file."/home/detroyejr/.config/kitty/Tokyo Night Day.conf".text = "
    # vim:ft=kitty
    
    ## name: Tokyo Night Day
    ## license: MIT
    ## author: Folke Lemaitre
    ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty_tokyonight_day.conf
    
    background #e1e2e7
    foreground #3760bf
    selection_background #99a7df
    selection_foreground #3760bf
    url_color #387068
    cursor #3760bf
    
    # Tabs
    active_tab_background #2e7de9
    active_tab_foreground #d4d6e4
    inactive_tab_background #c4c8da
    inactive_tab_foreground #8990b3
    #tab_bar_background #e9e9ed
    
    # normal
    color0 #e9e9ed
    color1 #f52a65
    color2 #587539
    color3 #8c6c3e
    color4 #2e7de9
    color5 #9854f1
    color6 #007197
    color7 #6172b0
    
    # bright
    color8 #a1a6c5
    color9 #f52a65
    color10 #587539
    color11 #8c6c3e
    color12 #2e7de9
    color13 #9854f1
    color14 #007197
    color15 #3760bf
    
    # extended colors
    color16 #b15c00
    color17 #c64343
  ";
}