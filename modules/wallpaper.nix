{ pkgs, lib, ... }:

let
  wallpaperSources = [
    {
      name = "etna";
      url = "https://unsplash.com/photos/m96cH5FOXOM/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzY2MTE1MDU3fA&force=true";
      sha256 = "sha256:02ml53yb27qssn4sgfdp6f3xx4yvy8bwciqzpdzm21lwjal0kylq";
    }
    {
      name = "poon-hill";
      url = "https://unsplash.com/photos/v7daTKlZzaw/download?force=true";
      sha256 = "sha256:1ijl3rhjyg161b2zbg541l3f5nj8yqvr2vxnjjyyj4izs7y8vgdc";
    }
  ];

  mkWall =
    image:
    let
      src = builtins.fetchurl {
        inherit (image) name url sha256;
      };
    in
    pkgs.stdenv.mkDerivation {
      name = "wall-${image.name}";
      version = "1.0";
      inherit src;

      phases = [ "installPhase" ];
      buildInputs = [ pkgs.imagemagick ];
      installPhase = ''
        mkdir -p $out
        magick "${src}" -resize 1920x1080^ "$out/medium.jpg"
        cp "${src}" "$out/wallpaper.jpg"
      '';
    };
  walls = map mkWall wallpaperSources;
in
{
  options = {
    walls = lib.mkOption {
      default = walls;
      type = lib.types.listOf lib.types.package;
      description = "List of wallpaper derivations with resized variants.";
    };
    wallpaper = lib.mkOption {
      default = "${builtins.head walls}/wallpaper.jpg";
      type = lib.types.path;
      description = "Default wallpaper path used by various modules.";
    };
  };
}
