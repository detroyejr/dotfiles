{pkgs, config, hyprland, ...}:
{
  programs.waybar = {
    enable = true;
    package = hyprland.packages.x86_64-linux.waybar-hyprland;
  };

  home.file.".config/waybar" = {
    source = ../../../dotfiles/waybar;
    recursive = true;
  };
}
