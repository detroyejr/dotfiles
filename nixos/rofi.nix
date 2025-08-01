{
  pkgs,
  config,
  ...
}:
let
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
      # Patch font, colors, and wallpaper.
      find files -type f -name "*.rasi" -exec sed -i 's/font:.*$/font: "${config.font.name} ${config.font.size}";/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background:.*$/background: #${config.colorScheme.colors.base00};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/background-alt:.*$/background-alt: #${config.colorScheme.colors.base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/foreground:.*$/foreground: #${config.colorScheme.colors.base06};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/selected:.*$/selected: #${config.colorScheme.colors.base02};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/active:.*$/active: #${config.colorScheme.colors.base04};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/urgent:.*$/urgent: #${config.colorScheme.colors.base01};/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].png/wallpaper.png/g' {} ';';
      find files -type f -name "*.rasi" -exec sed -i 's/[a-j].jpg/wallpaper.png/g' {} ';';
      find files -type f -name "*.rasi" -exec \
        sed -i "s,~/.config/rofi/images/wallpaper.png,${config.colorScheme.rofi},g" {} ';';

      # Patch powermenu icons.
      find files -type f -name "powermenu.sh" -exec sed -i "s/hibernate='.*'/hibernate='󰤄'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/shutdown='.*'/shutdown='⏻'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/reboot='.*'/reboot='󰜉'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/lock='.*'/lock=''/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/suspend='.*'/suspend='󰾊'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/logout='.*'/logout='󰍃'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/yes='.*'/yes=''/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/no='.*'/no='󰬟'/g" {} ';';
      find files -type f -name "powermenu.sh" -exec sed -i "s/\".*\$uptime\"/\" Uptime: \$uptime\"/g" {} ';';
    '';
  };
  rofi-launcher = pkgs.writeScriptBin "rofi-launcher" ''
    dir="${rofi-themes}/files/launchers/type-6"
    theme='style-3'

    ## Run
    rofi \
      -show drun \
      -theme ''${dir}/''${theme}.rasi
  '';
  rofi = pkgs.stdenv.mkDerivation {
    pname = "rofi";
    version = "1.0";
    src = rofi-themes;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin $out/share/rofi && cp -r files $out/share/rofi
      cp ${rofi-launcher}/bin/rofi-launcher $out/bin/rofi-launcher
      cp files/powermenu/type-6/powermenu.sh $out/bin/powermenu
      sed -i "s,dir=\".*\",dir=\"${rofi-themes}/files/powermenu/type-6\",g" $out/bin/powermenu 
    '';
  };
in
{
  users.users.detroyejr.packages = with pkgs; [
    rofi
    rofi-wayland
    rofi-power-menu
  ];
}
