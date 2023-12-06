# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../default.nix
      ../../modules/fonts
      ../../modules/brightness
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "Surface-NixOS"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services = {
    xserver = {
      enable = true;
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "detroyejr";
      displayManager.gdm.enable = true;
      libinput = {
        enable = true;
        touchpad = {
          scrollMethod = "twofinger";
          naturalScrolling = false;
        };
      };
    };
    gnome.gnome-keyring.enable = true;
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  # Recent change. Adding this prevents errors.
  programs.zsh.enable = true;
  users.users.detroyejr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      docker
      virtiofsd
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    enableNvidiaPatches = false;
  };

  programs.thunar = {
    enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    dislocker
    efibootmgr
    gcc
    rclone
    sbctl
    wget
    wl-clipboard
  ];

  # For sway.
  security.polkit.enable = true;
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  systemd.services.sbctl_sign = {
    path = [ pkgs.sbctl pkgs.gawk pkgs.util-linux ];
    script = ''
      sbctl verify | awk 'NR>1{print $2}' | xargs -L1 sbctl sign
    '';
    serviceConfig = {
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.onedrive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p /home/detroyejr/OneDrive/
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 10G \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-onedrive.log \
          --umask 022 \
          --uid 1000 \
          --gid 1000 \
          --allow-other \
          --config=$FILE \
          "OneDrive:" "/home/detroyejr/OneDrive/"
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google_drive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p "/home/detroyejr/Google Drive"
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 20G \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-google.log \
          --umask 022 \
          --uid 1000 \
          --gid 1000 \
          --allow-other \
          --config=$FILE \
          "Google Drive:" "/home/detroyejr/Google Drive/"
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.11"; # Did you read the comment?
}

