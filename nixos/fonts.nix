{ pkgs, config, ... }:
let

  input-fonts-nf = pkgs.input-fonts.overrideAttrs (oldAttrs: {
    patchPhase = ''
      mkdir tmp
      for path in InputMono InputSans; do
        find Input_Fonts/$path -iname "*.ttf" -exec ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher {} -out tmp \;
        mv tmp/* Input_Fonts/$path 
      done
    '';
  });
  in
{
  config.
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      input-fonts-nf
      nerd-fonts.blex-mono
      nerd-fonts.ubuntu
      ubuntu_font_family
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Input Serif"
          "Ubuntu"
        ];
        sansSerif = [
          "Input Serif"
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
