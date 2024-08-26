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

  services.syncthing = {
    enable = true;
    user = "detroyejr";
    dataDir = "/home/detroyejr/Documents";
    configDir = "/home/detroyejr/.config/syncthing";
  };

  networking.firewall.allowedTCPPorts = [22 80 22000 8000];
  networking.firewall.allowedUDPPorts = [53 22000 51820];

  services.libinput.touchpad.disableWhileTyping = true;

  system.stateVersion = "23.11";
}
