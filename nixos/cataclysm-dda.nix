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
    let
      version = "2024-10-27";
    in
    lib.recursiveUpdate super {
      soundpack.CC-Sounds = cddaLib.buildSoundPack {
        inherit version;
        modName = "CC-Sounds";
        src = pkgs.fetchzip {
          url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/${version}/CC-Sounds.zip";
          hash = "sha256-Or2gXcaVtcS7NPWKPvy5Lo4BgyrrU1kZpYLcyOuVxZM=";
        };
      };
    };

  cdda = (cddaLib.attachPkgs cddaLib.pkgs cdda-no-mod).withMods (
    mods: with mods.extend customMods; [
      soundpack.CC-Sounds
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
