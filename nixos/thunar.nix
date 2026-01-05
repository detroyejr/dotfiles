{ pkgs, ... }:
{
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [ xfce4-exo ];
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
