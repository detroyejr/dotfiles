{ config, pkgs, lib, ... }:
{
  fonts = {
    enableDefaultFonts = true;
      fonts = with pkgs; [ 
        ubuntu_font_family
        (nerdfonts.override { fonts = [ "CascadiaCode" "Ubuntu" ]; })
       ];

    fontconfig = {
      defaultFonts = {
        serif = [ "CaskaydiaCove NF Serif" "Ubuntu" ];
        sansSerif = [ "CaskaydiaCove NF" "Ubuntu" ];
        monospace = [ "CaskaydiaCove NF Mono" "Ubuntu" ];
      };
    };
  };
}
