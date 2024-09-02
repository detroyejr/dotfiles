{pkgs, ...}: let
  myPlex = pkgs.plex.overrideAttrs (_: rec {
    version = "1.40.5.8854-f36c552fd";
    src = pkgs.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      hash = "sha256-34DHJQbGiXJndCWOplNE5aics82CcR33lj28AAQvI8Y=";
    };
  });
in {
  fileSystems."/run/media/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
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
