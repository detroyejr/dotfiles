{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../actual.nix
    ../binary-cache.nix
    ../brightness.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../fonts.nix
    ../hyprland.nix
    ../openrgb.nix
    ../rclone.nix
    ../sops.nix
    ../steam.nix
    ../syncthing.nix
    ../thunar.nix
    ../veikk.nix
    ../virtualization.nix
  ];

  networking.hostName = "mini-1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.authorizedKeysFiles = [
    "/home/detroyejr/.ssh/main_server_ed25519.pub"
  ];

  fileSystems."/run/mount/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = [
      "rw"
      "relatime"
      "user"
    ];
  };

  networking.wireless.enable = false;
  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.1.222";
      prefixLength = 24;
    }
  ];

  networking.firewall.allowedTCPPorts = [
    22
    80
    5678
    8000
    11434
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 4 * * * root reboot > /dev/null 2>&1"
    ];
  };

  system.stateVersion = "23.11";
}
