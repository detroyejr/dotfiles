{
  pkgs,
  lib,
  config,
  ...
}:
let
  walls = pkgs.stdenv.mkDerivation {
    name = "walls";
    version = "1.0";
    src = builtins.fetchurl {
      name = "wallpaper";
      url = "https://unsplash.com/photos/m96cH5FOXOM/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzY2MTE1MDU3fA&force=true";
      sha256 = "sha256:02ml53yb27qssn4sgfdp6f3xx4yvy8bwciqzpdzm21lwjal0kylq";
    };

    phases = [ "installPhase" ];
    buildInputs = [ pkgs.imagemagick ];
    installPhase = ''
      mkdir $out

      magick $src -resize 800x600^ rofi.jpg
      magick $src -resize 1920x1080^ medium.jpg

      mv rofi.jpg $out
      cp medium.jpg $out/medium.jpg
      cp $src $out/wallpaper.jpg

    '';
  };
in
{

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
      wallpaper = lib.mkOption {
        default = "${walls}/wallpaper.jpg";
        type = lib.types.path;
        description = "Default wallpaper path used by various modules.";
      };
      rofi = lib.mkOption {
        default = "${walls}/rofi.jpg";
        type = lib.types.path;
        description = "Wallpaper variant for rofi/menus.";
      };
      profile = lib.mkOption {
        default = ../assets/profile.png;
        type = lib.types.path;
        description = "User profile image used by modules (e.g. hyprlock).";
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

    # Hyprlock options (user-overridable)
    hyprlock = {
      imageSize = lib.mkOption {
        default = "400";
        type = lib.types.str;
        description = "Profile image size used by hyprlock (px).";
      };
      imagePosition = lib.mkOption {
        default = "0,270";
        type = lib.types.str;
        description = "Profile image position for hyprlock (x,y).";
      };
      inputFieldSize = lib.mkOption {
        default = "350, 90";
        type = lib.types.str;
        description = "Input-field size used by hyprlock (width, height).";
      };

      inputFieldPosition = lib.mkOption {
        default = "0, -130";
        type = lib.types.str;
        description = "Input-field position used by hyprlock (x, y).";
      };

      labelPosition = lib.mkOption {
        default = "0,550";
        type = lib.types.str;
        description = "Label position used by hyprlock (x,y).";
      };
    };
  };

  # Computed hyprlock defaults for specific systems.
  config = lib.mkIf (config.system.name == "pelican") {
    hyprlock = {
      imageSize = lib.mkDefault "300";
      imagePosition = lib.mkDefault "0,100";
      inputFieldSize = lib.mkDefault "250, 80";
      inputFieldPosition = lib.mkDefault "0, -130";
      labelPosition = lib.mkDefault "0,350";
    };
  };
}
