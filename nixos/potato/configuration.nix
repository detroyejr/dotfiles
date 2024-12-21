{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../cataclysm-dda.nix
    ../cosmic.nix
    ../fonts.nix
    ../syncthing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "potato"; # Define your hostname.

  programs.firefox.enable = true;
  environment.systemPackages = [
    pkgs.calibre
    pkgs.obsidian 
    pkgs.plex-desktop 
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
