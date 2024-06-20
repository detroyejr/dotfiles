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

  networking.hostName = "mini-1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "23.11";
}
