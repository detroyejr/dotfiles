{ pkgs, ... }:
{
  fileSystems."/run/media/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = ["rw" "relatime" "vers=4.2" "rsize=524288" "wsize=524288" ];
  };
  services.plex = {
    enable = true;
    openFirewall = true;
    accelerationDevices = [ "*" ];
    user = "root";
  };
}
