{ config, pkgs, lib, ... }:
{
  fonts = {
    enableDefaultPackages = true;
      packages = with pkgs; [ 
        ubuntu_font_family
        (nerdfonts.override { fonts = [ "IBMPlexMono" "Ubuntu" ]; })
       ];

    fontconfig = {
      defaultFonts = {
        serif = [ "BlexMono NF Serif" "Ubuntu" ];
        sansSerif = [ "BlexMono NF" "Ubuntu" ];
        monospace = [ "BlexMono NF Mono" "Ubuntu" ];
      };
    };
  };
}
