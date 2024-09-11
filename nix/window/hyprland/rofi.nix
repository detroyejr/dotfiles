{
  pkgs,
  colorScheme,
  rofi-background,
  ...
}: let
  rofi-themes = pkgs.stdenv.mkDerivation {
    name = "rofi-themes";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "3f2275ab8f9dbb697c7387a20a78a3da196c302a";
      sha256 = "sha256-slq48vZlVLmFn4K+ET0uZeFQJYr7+lGxAzvvPHXj/NU=";
    };
    installPhase = ''
      cp -r . $out;
    '';
    patchPhase = ''
      find files -type f -name "*.rasi" -exec sed -i 's/font:.*$/font: "BlexMono Nerd Font Mono 12";/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background:.*$/background: #${colorScheme.colors.base00};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background-alt:.*$/background-alt: #${colorScheme.colors.base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/foreground:.*$/foreground: #${colorScheme.colors.base06};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/selected:.*$/selected: #${colorScheme.colors.base02};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/active:.*$/active: #${colorScheme.colors.base04};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/urgent:.*$/urgent: #${colorScheme.colors.base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].png/wallpaper.png/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].jpg/wallpaper.png/g' {} ';';
      cp ${rofi-background} files/images/wallpaper.png
    '';
  };
in {
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
