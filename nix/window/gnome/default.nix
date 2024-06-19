{
  config,
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-Macchiato-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "compact";
        tweaks = ["rimless" "black"];
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
      workspace-names = ["Main"];
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
    papirus-icon-theme
    gnome.gnome-shell
    gnome.gnome-themes-extra
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.extension-list
    gnomeExtensions.floating-panel
    gnomeExtensions.move-clock
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.upower-battery
    gnomeExtensions.user-themes
    papirus-icon-theme
  ];
}
