{pkgs, ...}: {
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [xfce.exo];
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
