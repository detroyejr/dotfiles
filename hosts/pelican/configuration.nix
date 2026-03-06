{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/apps/cataclysm-dda.nix
    ../../modules/apps/steam.nix
    ../../modules/apps/thunar.nix
    ../../modules/apps/wireshark.nix
    ../../modules
  ];

  programs = {
    git.enable = true;
    tmux.enable = true;
    opencode.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
    zsh.enable = true;
    hyprland.enable = true;
    firefox.enable = true;
    cataclysmdda.enable = true;
    steam.enable = true;
    thunar.enable = true;
    wireshark.enable = true;
    neovim.enable = true;
    python.enable = true;
    r.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pelican";

  services = {
    docker.enable = false;
    fprintd.enable = true;
    openrgb.enable = true;
    rclone = {
      onedrive.enable = true;
      googleDrive.enable = true;
    };
    syncthing.enable = true;
    tlp.enable = true;
    virtualization.enable = false;

    libinput.touchpad.disableWhileTyping = true;
  };

  system.stateVersion = "24.05";
}
