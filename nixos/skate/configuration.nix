{ pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../cataclysm-dda.nix
    ../fonts.nix
    ../jovian.nix
    ../syncthing.nix
  ];

  environment.systemPackages = with pkgs; [
    plex-htpc
  ];

  fileSystems."/home/detroyejr/SD" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-hyperion
    ];
  };

  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.authorizedKeysFiles = [
    "/home/detroyejr/.ssh/main_server_ed25519.pub"
  ];

  networking.hostName = "skate";
  services.xserver.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.11";
}
