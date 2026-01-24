{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../apps/cataclysm-dda.nix
    ../../apps/fonts.nix
    ../../apps/steam.nix
    ../../apps/thunar.nix
    ../../apps/wireshark.nix
    ../../default.nix
    ../../devices.nix
    ../../hyprland/default.nix
    ../../hyprland/xdg.nix
    ../../services/docker.nix
    ../../services/openrgb.nix
    ../../services/rclone.nix
    ../../services/syncthing.nix
    ../../services/virtualization.nix
    ../../sops.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pelican";

  services.fprintd.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  services.tlp.enable = true;

  system.stateVersion = "24.05";
}
