# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../docker.nix
    ../plex.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.networkmanager.enable = true;
  networking.hostName = "BrickOS";
  # time.timeZone = "America/New_York";
  #
  # i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "en_US.UTF-8";
  #   LC_IDENTIFICATION = "en_US.UTF-8";
  #   LC_MEASUREMENT = "en_US.UTF-8";
  #   LC_MONETARY = "en_US.UTF-8";
  #   LC_NAME = "en_US.UTF-8";
  #   LC_NUMERIC = "en_US.UTF-8";
  #   LC_PAPER = "en_US.UTF-8";
  #   LC_TELEPHONE = "en_US.UTF-8";
  #   LC_TIME = "en_US.UTF-8";
  # };

  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  users.users.detroyejr = {
    isNormalUser = true;
    description = "Jonathan De Troye";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    home-manager
    nfs-utils
    nvtopPackages.full
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.logind.lidSwitch = "ignore";

  system.stateVersion = "23.11"; # Did you read the comment?
}
