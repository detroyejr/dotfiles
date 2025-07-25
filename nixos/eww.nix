{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.eww ];
  environment.etc = {
    "xdg/eww".source = ../dotfiles/eww;
  };
}
