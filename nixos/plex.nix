{ pkgs, ... }:
let
  myPlex = pkgs.plex.override {
    plexRaw = pkgs.plexRaw.overrideAttrs (out: rec {
      version = "1.40.5.8921-836b34c27";
      src = pkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        hash = "sha256-B/c9/wAQTkJ+Uzz7oLKzczAYx7U8DFB8DbvT/kwTKjo=";
      };
    });
  };
in
{
  fileSystems."/run/media/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = ["rw" "relatime" "vers=4.2" "rsize=524288" "wsize=524288" ];
  };
  services.plex = {
    package = myPlex;
    enable = true;
    openFirewall = true;
    accelerationDevices = [ "*" ];
    user = "root";
  };
}
