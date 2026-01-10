{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mako ];
  environment.etc = {
    "xdg/mako/mako.ini".source = ../../dotfiles/mako/mako.ini;
  };
}
