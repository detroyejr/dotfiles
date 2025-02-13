{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../brightness.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../docker.nix
    ../flatpak.nix
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

  # Wireguard needs these extra rules. See the nixos wiki
  # for more details.
  networking.firewall = {
    logReversePathDrops = true;
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    8000
    51820
    52415
    1337
  ];
  networking.firewall.allowedUDPPorts = [
    53
    51820
    1337
    8000
    52415
    5678
  ];

  services.libinput.touchpad.disableWhileTyping = true;
  services.tlp.enable = true;
  system.stateVersion = "23.11";
}
