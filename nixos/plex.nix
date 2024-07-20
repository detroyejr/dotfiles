{ pkgs, ... }:
let
  myPlex = pkgs.plex.overrideAttrs (_: rec {
    version = "1.40.3.8555-fef15d30c";
    src = pkgs.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      hash = "sha256-mJZHvK2dEaeDmmDwimBn606Ur89yPs/pitzuTFVPS1Q=";
    };
  });
  in
{
  fileSystems."/run/media/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = [ "nfsvers=4" "rw" ];
  };
  services.plex = {
    package = myPlex;
    enable = true;
    openFirewall = true;
    accelerationDevices = [ "*" ];
    user = "root";
  };
}
