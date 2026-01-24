final: prev: {
  rofi-themes = prev.stdenv.mkDerivation {
    name = "rofi-themes";
    src = prev.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "3f2275ab8f9dbb697c7387a20a78a3da196c302a";
      sha256 = "sha256-slq48vZlVLmFn4K+ET0uZeFQJYr7+lGxAzvvPHXj/NU=";
    };
    installPhase = ''
      cp -r . $out;
                                                                                                                    
      # Patch powermenu icons.
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/hibernate='.*'/hibernate='󰤄'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/shutdown='.*'/shutdown='⏻'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/reboot='.*'/reboot='󰜉'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/lock='.*'/lock=''/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/suspend='.*'/suspend='󰾊'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/logout='.*'/logout='󰍃'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/yes='.*'/yes=''/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/no='.*'/no='󰬟'/g" {} ';';
      find $out/files -type f -name "powermenu.sh" -exec sed -i "s/\".*\$uptime\"/\" Uptime: \$uptime\"/g" {} ';';
    '';
  };
}
