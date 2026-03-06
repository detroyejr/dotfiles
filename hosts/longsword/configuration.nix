{ pkgs, ... }:
{
  networking = {
    hostName = "longsword";

    # Wireguard needs these extra rules. See the nixos wiki
    # for more details.
    firewall = {
      logReversePathDrops = true;
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
      allowedTCPPorts = [
        80
        8000
        51820
        52415
        1337
      ];
      allowedUDPPorts = [
        53
        51820
        1337
        8000
        52415
        5678
      ];
    };
  };

  programs = {
    cataclysmdda.enable = true;
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    firefox.enable = true;
    git.enable = true;
    hyprland.enable = true;
    neovim.enable = true;
    opencode.enable = true;
    python.enable = true;
    r.enable = true;
    steam.enable = true;
    thunar.enable = true;
    thunderbird.enable = false;
    tmux.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  services = {
    hardware.openrgb.enable = true;
    rclone = {
      onedrive.enable = true;
      googleDrive.enable = true;
    };
    syncthing.enable = true;
    fprintd.enable = true;
    libinput.touchpad.disableWhileTyping = true;
    tlp.enable = true;
    udev.packages = [ pkgs.rtl-sdr-librtlsdr ];
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "23.11";
}
