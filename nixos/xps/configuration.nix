{...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../brightness.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../fonts.nix
    ../hyprland.nix
    ../rclone.nix
    ../steam.nix
    ../thunar.nix
    ../virtualization.nix
  ];

  networking.hostName = "XPS-Nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
