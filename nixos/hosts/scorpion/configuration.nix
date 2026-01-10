{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
    ../../services/docker.nix
    ../../services/plex.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.networkmanager.enable = true;
  networking.hostName = "scorpion";

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

  services.logind.settings.Login.HandleLidSwitch = "Ignore";

  system.stateVersion = "23.11";
}
