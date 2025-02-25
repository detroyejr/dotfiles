{ pkgs,lib, config, ... }:
let

  input-fonts-nf = pkgs.input-fonts.overrideAttrs (oldAttrs: {
    patchPhase = ''
      mkdir tmp
      for path in InputMono InputSans; do
        find Input_Fonts/$path -iname "*.ttf" -exec ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher {} -out Input_Fonts/$path \;
      done
    '';
  });
  in
{

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      input-fonts-nf
      helvetica-neue-lt-std
      nerd-fonts.blex-mono
    ];

    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Input Serif"
          "Ubuntu"
        ];
        sansSerif = [
          "Input Sans"
          "Ubuntu"
        ];
        monospace = [
          "Input Mono"
          "Ubuntu"
        ];
      };
    };
  };
}
