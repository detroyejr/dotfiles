{ config, pkgs, colorScheme, wallpaper, ... }:
let
  rofi-themes = pkgs.stdenv.mkDerivation {
    name = "rofi-themes";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "master";
      sha256 = "sha256-K6WQ+olSy6Rorof/EGi9hP2WQpRONjuGREby+aBlzYg=";
    };
    installPhase = ''
      cp -r . $out;
    '';
    patchPhase = with colorScheme.colors; ''
      find files -type f -name "*.rasi" -exec sed -i 's/font:.*$/font: "BlexMono Nerd Font Mono 12";/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background:.*$/background: #${base00};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background-alt:.*$/background-alt: #${base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/foreground:.*$/foreground: #${base06};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/selected:.*$/selected: #${base02};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/active:.*$/active: #${base04};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/urgent:.*$/urgent: #${base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].png/wallpaper.png/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].jpg/wallpaper.png/g' {} ';';
      cp ${wallpaper} files/images/wallpaper.png
    '';
  };
in
{

  home.packages = with pkgs; [
    rofi-wayland
    rofi-power-menu
  ];

  home.file.".config/rofi/".source = rofi-themes + "/files";
  home.file.".local/bin/rofi-launcher" = {
    text = ''
      dir="$HOME/.config/rofi/launchers/type-7"
      theme='style-3'

      ## Run
      rofi \
        -show drun \
        -theme ''${dir}/''${theme}.rasi
    '';
    executable = true;
  };
}
