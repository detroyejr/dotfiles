{...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../brightness.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../docker.nix
    ../fonts.nix
    ../hyprland.nix
    ../rclone.nix
    ../steam.nix
    ../syncthing.nix
    ../thunar.nix
    ../virtualization.nix
  ];

  networking.hostName = "XPS-Nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.allowedTCPPorts = [80 8000];
  networking.firewall.allowedUDPPorts = [53 51820];

  services.libinput.touchpad.disableWhileTyping = true;

  system.stateVersion = "23.11";
}
