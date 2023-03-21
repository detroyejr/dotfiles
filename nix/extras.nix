{ config, pkgs, fetchFromGitHub, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-Macchiato-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };    
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
    };
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "rounded-window-corners@yilozt"
        "Move_Clock@rmy.pobox.com"
        "blur-my-shell@aunetx"
      ];
    };
    "org/gnome/shell/extensions/rounded-window-corners" = {
      border-width = 0;
      tweak-kitty-terminal = true;
    };
    # Configure blur-my-shell
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.85;
      dash-opacity = 0.25;
      sigma = 15; # Sigma means blur amount
      static-blur = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
  };
  home.sessionVariables.GTK_THEME = "Catppuccin-Macchiato-Compact-Blue-Dark";
  home.packages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-shell
    gnome.gnome-themes-extra
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.upower-battery
    gnomeExtensions.extension-list
    gnomeExtensions.floating-panel
    gnomeExtensions.move-clock
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.user-themes
    gtklock
    hyperion-ng
    hyprpaper
    socat
    gjs
    kitty
    papirus-icon-theme
    pamixer
    wireshark
    pavucontrol
    brightnessctl
    wl-clipboard
    wlsunset
    wofi
    dunst
  ];

  programs.rofi.enable = true;
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../assets/.config/eww;
  };

  home.file."/home/detroyejr/.config/hypr/hyprpaper.conf".text = "
    preload = ~/.config/dotfiles/assets/wallpaper.jpg
    wallpaper = DP-4,~/.config/dotfiles/assets/wallpaper.jpg
    wallpaper = eDP-1,~/.config/dotfiles/assets/wallpaper.jpg
  ";

  home.file."/home/detroyejr/.config/kitty/kitty.conf".text = "
    include ./Tokyo Night Day.conf
    include ./Tokyo Night.conf
    font_family CaskaydiaCove Nerd Font Mono
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
  home.file."/home/detroyejr/.config/kitty/Tokyo Night.conf".text = "
    # vim:ft=kitty

    ## name: Tokyo Night
    ## license: MIT
    ## author: Folke Lemaitre
    ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty/tokyonight_night.conf


    background #1a1b26
    foreground #c0caf5
    selection_background #33467c
    selection_foreground #c0caf5
    url_color #73daca
    cursor #c0caf5
    cursor_text_color #1a1b26

    # Tabs
    active_tab_background #7aa2f7
    active_tab_foreground #16161e
    inactive_tab_background #292e42
    inactive_tab_foreground #545c7e
    #tab_bar_background #15161e

    # Windows
    active_border_color #7aa2f7
    inactive_border_color #292e42

    # normal
    color0 #15161e
    color1 #f7768e
    color2 #9ece6a
    color3 #e0af68
    color4 #7aa2f7
    color5 #bb9af7
    color6 #7dcfff
    color7 #a9b1d6

    # bright
    color8 #414868
    color9 #f7768e
    color10 #9ece6a
    color11 #e0af68
    color12 #7aa2f7
    color13 #bb9af7
    color14 #7dcfff
    color15 #c0caf5

    # extended colors
    color16 #ff9e64
    color17 #db4b4b
  ";
}
