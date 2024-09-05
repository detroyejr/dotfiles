{ pkgs, ... }:
let
  myPlex = pkgs.plex.override {
    plexRaw = pkgs.plexRaw.overrideAttrs (out: rec {
      version = "v.1.40.5.8921-836b34c27";
      src = pkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        hash = "";
      };
    });
  };
  in
{
  fileSystems."/run/media/Media" = {
    device = "191.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = ["nfsvers=4" "rw"];
  };
  services.plex = {
    package = myPlex;
    enable = true;
    openFirewall = true;
    accelerationDevices = ["*"];
    user = "root";
  };
}
