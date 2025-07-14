{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../devices.nix
    ../brightness.nix
    ../cataclysm-dda.nix
    ../cataclysm-dda.nix
    # ../cosmic.nix
    ../docker.nix
    ../fonts.nix
    ../hyprland.nix
    ../openrgb.nix
    ../rclone.nix
    ../sops.nix
    ../steam.nix
    ../syncthing.nix
    ../thunar.nix
    ../virtualization.nix
    ../wireshark.nix
    ../xdg.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "potato";

  services.fprintd.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  services.tlp.enable = true;

  system.stateVersion = "24.05";
}
