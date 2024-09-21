{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../cataclysm-dda.nix
    ../fonts.nix
    ../kde.nix
    ../syncthing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "potato"; # Define your hostname.

  programs.firefox.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
    };
  };
  environment.systemPackages = [ pkgs.plex-desktop ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
