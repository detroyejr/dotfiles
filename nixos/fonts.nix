{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
      nerd-fonts.blex-mono
      nerd-fonts.ubuntu
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "BlexMono NF Serif"
          "Ubuntu"
        ];
        sansSerif = [
          "BlexMono NF"
          "Ubuntu"
        ];
        monospace = [
          "BlexMono NF Mono"
          "Ubuntu"
        ];
      };
    };
  };
}
