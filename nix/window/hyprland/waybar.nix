{pkgs, config, hyprland, ...}:
{
  programs.waybar = {
    enable = true;
  };

  home.file.".config/waybar" = {
    source = ../../../dotfiles/waybar;
    recursive = true;
  };
}
