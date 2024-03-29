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

  base-cdda = pkgs.cataclysm-dda-git.override {
    version = "2024-03-02";
    rev = "7ee6c6a6a42596eba935fdb7270a801bb2e1b314";
    sha256 = "sha256-z7wSI328J8FsYr/BcOYkLaTeeOLbme76AaSZz/JkWlo=";
  };

  cdda-no-mod = base-cdda.overrideAttrs (super: {
    # patch doesn't cleanly apply anymore
    patches = [ ];

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
