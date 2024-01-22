{ pkgs, lib, ... }:
let
  cddaLib = {
    inherit
      (pkgs.cataclysmDDA)
      attachPkgs
      buildMod
      buildSoundPack
      buildTileSet
      pkgs
      wrapCDDA
      ;
  };

  cdda-no-mod = pkgs.cataclysm-dda.overrideAttrs (super: {
    # patch doesn't cleanly apply anymore
    patches = with pkgs; super.patches ++ [
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-dangling-reference-warning.patch";
        hash = "sha256-9nPbyz49IYBOVHqr7jzCIyS8z/SQgpK4EjEz1fruIPE=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-cstdint.patch";
        hash = "sha256-8IBW2OzAHVgEJZoViQ490n37sl31hA55ePuqDL/lil0=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-keyword-requires.patch";
        hash = "sha256-8yvHh0YKC7AC/qzia7AZAfMewMC0RiSepMXpOkMXRd8=";
      })
    ];

    passthru =
      super.passthru
      // {
        pkgs = pkgs.override { build = cdda-no-mod; };
        withMods = cddaLib.wrapCDDA cdda-no-mod;
      };
  });

  customMods = self: super:
    lib.recursiveUpdate super {
      soundpack.CC-Sounds = cddaLib.buildSoundPack {
        modName = "CC-Sounds";
        version = "2023-12-10";
        src = pkgs.fetchzip {
          url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/2023-12-10/CC-Sounds.zip";
          hash = "sha256-X0da9cs60sr5jq4TPTMkNQAHAjcu1gPagJyLDJ7HOe0=";
        };
      };
    };

  cdda = (cddaLib.attachPkgs cddaLib.pkgs cdda-no-mod).withMods (mods:
    with mods.extend customMods; [
      soundpack.CC-Sounds
      tileset.UndeadPeople
    ]);

  cdda-desktop = pkgs.makeDesktopItem {
    name = "cataclysm-dda";
    desktopName = "Cataclysm Dark Days Ahead (Post-apocalyptic survival game)";
    exec = "${cdda}/bin/cataclysm-tiles";
  };
in
{
  home.packages = [ cdda-desktop ];
}
