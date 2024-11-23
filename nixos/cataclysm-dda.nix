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
    version = "0.H-RELEASE";
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
        version = "2024-01-17";
        src = pkgs.fetchzip {
          url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/2024-01-17/CC-Sounds.zip";
          hash = "sha256-i2b++XPcV1IJeDZF1TC9C325XTn55TVa57xTdtYNV8g=";
        };
      };
      tileset.UndeadPeopleCustom = cddaLib.buildTileSet {
        modName = "UndeadPeopleCustom";
        version = "Tutti Frutti (August Release 2) Latest";
        src = pkgs.fetchzip {
          url = "https://github.com/Theawesomeboophis/UndeadPeopleTileset/releases/download/8%2F16%2F24/Sprinkles.zip";
          hash = "sha256-4PVliOuhow9KFd79bDqLdEpoKmbLK+5U4NzNnib+uRU=";
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
