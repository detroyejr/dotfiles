{...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../hyprland.nix
    ../rclone.nix
    ../steam.nix
    ../thunar.nix
    ../virtualization.nix
    ../../nix/fonts
    ../../nix/brightness
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mini-1";
  networking.firewall.enable = false;
  
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "23.11";
}
