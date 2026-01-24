{
  pkgs,
  config,
  lib,
  ...
}:
let
  nextWallpaper = pkgs.writeScriptBin "next-wallpaper" ''
    # Collect paths into an array.
    export themePaths=(${lib.concatStringsSep " " config.themes})
    export index=''$((RANDOM % ''${#themePaths[@]}))
    currentTheme="''${themePaths[''$index]}"
    if [ -d /etc/xdg/CURRENT_THEME ]; then 
      unlink /etc/xdg/CURRENT_THEME; 
    fi;
    ln -s $currentTheme /etc/xdg/CURRENT_THEME
    hyprctl hyprpaper wallpaper ,''$currentTheme/wallpaper/wallpaper.jpg
  '';

  mkHyprpaper =
    wall:
    pkgs.writeText "hyprpaper.conf" ''
      splash = true
      preload = ${toString wall}

      wallpaper {
          monitor =
          path = ${toString wall}
      }
    '';

  mkLockscreen =
    wall:
    pkgs.writeText "hyprlock.conf" ''
      background {
        monitor=
        blur_passes=1
        blur_size=7
        path=${wall}/wallpaper.jpg
      }

      image {
        monitor=
        size=${config.hyprlock.imageSize}
        halign=center
        path=${config.hyprlock.profile}
        position=${config.hyprlock.imagePosition}
        rounding=-1
        valign=center
      }

      input-field {
        monitor=
        size=${config.hyprlock.inputFieldSize}
        dots_size=0.300000
        dots_spacing=0.400000
        font_color=rgba(${config.colorScheme.colors.base04}FF)
        halign=center
        inner_color=rgba(${config.colorScheme.colors.base02}FF)
        outer_color=rgba(${config.colorScheme.colors.base09}FF)
        outline_thickness=2
         position=${config.hyprlock.inputFieldPosition}
        valign=center
      }

      label {
        monitor=
        color=rgba(${config.colorScheme.colors.base04}FF)
        font_family=${config.font.name}
        font_size=65
        halign=center
        position=${config.hyprlock.labelPosition}
        rotate=0
        text=$TIME
        text_align=center
        valign=center
      }
    '';

  mkRofiTheme =
    walls: colorScheme: font:
    pkgs.rofi-themes.overrideAttrs (attrs: {
      pname = "rofi-theme-${walls.name}";
      version = "1.0";
      src = pkgs.rofi-themes;
      buildInputs = [ pkgs.imagemagick ];

      patchPhase = ''
        # Rofi opens much faster when the wallpaper is a more manageable size.
        magick "${walls}/wallpaper.jpg" -resize 800x600^ "rofi.png"

        # Patch font, colors, and wallpaper.
        find files -type f -name "*.rasi" -exec sed -i 's/font:.*$/font: "${font.name} ${font.size}";/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/background:.*$/background: #${colorScheme.colors.base00};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/background-alt:.*$/background-alt: #${colorScheme.colors.base01};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/foreground:.*$/foreground: #${colorScheme.colors.base06};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/selected:.*$/selected: #${colorScheme.colors.base02};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/active:.*$/active: #${colorScheme.colors.base04};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/urgent:.*$/urgent: #${colorScheme.colors.base01};/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/[a-j].png/wallpaper.png/g' {} ';';
        find files -type f -name "*.rasi" -exec sed -i 's/[a-j].jpg/wallpaper.png/g' {} ';';
        find files -type f -name "*.rasi" -exec \
          sed -i "s,~/.config/rofi/images/wallpaper.png,$out/rofi.png,g" {} ';';

        mkdir -p $out/bin
        cat << EOF > $out/bin/rofi-launcher
          rofi \
            -show drun \
            -theme $out/files/launchers/type-6/style-3.rasi
        EOF
        chmod +x $out/bin/rofi-launcher
      '';
    });

  mkTheme =
    wall: colorScheme: font:
    pkgs.stdenv.mkDerivation {
      name = "theme-${wall.name}";
      version = "1.0";
      src = null;

      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/hypr $out/waybar $out/mako
        ln -sfn ${wall} $out/wallpaper
        ln -sfn ${mkRofiTheme wall colorScheme font} $out/rofi
        ln -sfn ${mkLockscreen wall} $out/hypr/hyprlock.conf
        ln -sfn ${mkHyprpaper wall} $out/hypr/hyprpaper.conf

        ln -sfn ${pkgs.writeText "config.css" ''
          @define-color accent #${config.colorScheme.colors.base08};
        ''} $out/waybar/config.css
        ln -sfn ${../dotfiles/waybar/config} $out/waybar/config
        ln -sfn ${../dotfiles/waybar/style.css} $out/waybar/style.css
        ln -sfn ${../dotfiles/mako/mako.ini} $out/mako/mako.ini
      '';
    };

in
{
  imports = [
    ./hyprlock.nix
    ./rofi.nix
    ./wallpaper.nix
  ];

  options = {
    font = lib.mkOption {
      default = {
        name = "Input Mono";
        size = "11";
        scale = "1";
      };
      type = lib.types.attrs;
      description = "Font settings used across the UI (name, size, scale).";
    };
    cursor = lib.mkOption {
      default = {
        name = "Bibata-Modern-Ice";
        size = "14";
        package = pkgs.bibata-cursors;
      };
      type = lib.types.attrs;
      description = "Cursor theme settings (cursor name, size and package).";
    };
    colorScheme = {
      name = lib.mkOption {
        default = "rose-pine";
        type = lib.types.str;
        description = "Human-friendly color scheme name.";
      };
      slug = lib.mkOption {
        default = "rose-pine";
        type = lib.types.str;
        description = "Machine-friendly color scheme identifier (slug).";
      };
      colors = lib.mkOption {
        default = {
          base00 = "191724";
          base01 = "1f1d2e";
          base02 = "26233a";
          base03 = "6e6a86";
          base04 = "908caa";
          base05 = "e0def4";
          base06 = "e0def4";
          base07 = "524f67";
          base08 = "eb6f92";
          base09 = "f6c177";
          base0A = "ebbcba";
          base0B = "31748f";
          base0C = "9ccfd8";
          base0D = "c4a7e7";
          base0E = "f6c177";
          base0F = "524f67";
        };
        type = lib.types.attrsOf lib.types.str;
        description = "Palette of hex color values (without '#') used by the theme.";
      };
    };
    themes = lib.mkOption {
      default = map (wall: mkTheme wall config.colorScheme config.font) config.walls;
      type = lib.types.listOf lib.types.package;
      description = "List of wallpaper derivations with resized variants.";
    };
  };

  config = {
    environment.systemPackages = [ nextWallpaper ];
    system.activationScripts = {
      setTheme = ''
        # Collect paths into an array.
        export themePaths=(${lib.concatStringsSep " " config.themes})
        export index=''$((RANDOM % ''${#themePaths[@]}))
        currentTheme="''${themePaths[''$index]}"
        if [ -d /etc/xdg/CURRENT_THEME ]; then 
          unlink /etc/xdg/CURRENT_THEME; 
        fi;
        ln -s $currentTheme /etc/xdg/CURRENT_THEME
      '';
    };
  };
}
