{ pkgs, lib, ... }:
let
  cddaLib = {
    inherit (pkgs.cataclysmDDA)
      attachPkgs
      buildMod
      buildSoundPack
      buildTileSet
      pkgs
      wrapCDDA
      ;
  };

  base-cdda = pkgs.cataclysm-dda-git.override {
    version = "cdda-0.H-2024-10-14-1533";
    sha256 = "sha256-IodXEA+pWfDdR9huRXieP3+J3WZJO19C8PUPT18dFBw=";
  };

  cdda-no-mod = base-cdda.overrideAttrs (super: {
    # patch doesn't cleanly apply anymore
    patches = [ ];

    passthru = super.passthru // {
      pkgs = pkgs.override { build = cdda-no-mod; };
      withMods = cddaLib.wrapCDDA cdda-no-mod;
    };
  });

  customMods =
    self: super:
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

  cdda = (cddaLib.attachPkgs cddaLib.pkgs cdda-no-mod).withMods (
    mods: with mods.extend customMods; [
      soundpack.CC-Sounds
      tileset.UndeadPeopleCustom
    ]
  );

  cdda-desktop = pkgs.makeDesktopItem {
    name = "cataclysm-dda";
    desktopName = "Cataclysm Dark Days Ahead (Post-apocalyptic survival game)";
    exec = "${cdda}/bin/cataclysm-tiles";
    icon = "${cdda}/share/icons/hicolor/scalable/apps/org.cataclysmdda.CataclysmDDA.svg";
  };
in
{
  environment.systemPackages = [ cdda-desktop ];
}
