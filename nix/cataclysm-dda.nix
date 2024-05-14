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
    version = "2024-05-12";
    rev = "39e2afa80d50b06c8e3d13bdb6fc8dbeb23a1a63";
    sha256 = "sha256-Y378fczn/YKxdyW18c193OvvBil7xt9GV1SH0QRk5Q0=";
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
      tileset.UndeadPeopleCustom = cddaLib.buildTileSet {
        modName = "UndeadPeopleCustom";
        version = "March Release 1";
        src = pkgs.fetchzip {
          url = "https://github.com/Theawesomeboophis/UndeadPeopleTileset/releases/download/3%2F4%2F24/Sprinkles.zip";
          hash = "sha256-5X8jvxIe6FW/PG5k5TvuGenlUU66FFft6TyjAeCq7ts=";
          stripRoot = false;
        };
      };
    };

  cdda = (cddaLib.attachPkgs cddaLib.pkgs cdda-no-mod).withMods (mods:
    with mods.extend customMods; [
      soundpack.CC-Sounds
      tileset.UndeadPeopleCustom
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
