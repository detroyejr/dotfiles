{ colorScheme, ... }:
{
  programs.waybar = {
    enable = true;
  };

  home.file.".config/waybar/config".source = ../../../dotfiles/waybar/config;
  home.file.".config/waybar/style.css".source = ../../../dotfiles/waybar/style.css;
  home.file.".config/waybar/config.css".text = ''
    @define-color accent #${colorScheme.colors.base08};
  '';

}
