{ pkgs, ... }:
{
  fileSystems."/run/media/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
  };
  services.plex = {
    enable = true;
    openFirewall = true;
    accelerationDevices = [ "/dev/dri/card0" "/dev/dri/card1" ];
    user = "root";
  };
}
