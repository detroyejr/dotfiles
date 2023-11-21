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

  # networking.hostName = "nixos"; # Define your hostname.
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
      #dpi = 267;
    };
    gnome.gnome-keyring.enable = true;
  };

  #nixpkgs.config.packageOverrides = pkgs: {
  #  vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  #};

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  # Recent change. Adding this prevents errors.
  programs.zsh.enable = true;
  users.users.detroyejr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      docker
    ];
  }; 

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
      sbctl verify | grep nixos | awk '{print $2}' | xargs -L1 sbctl sign
      sbctl verify | grep Microsoft/Boot/b | awk '{print $2}' | xargs -L1 sbctl sign
      sbctl verify | grep Microsoft/Boot/en-US/b | awk '{print $2}' | xargs -L1 sbctl sign
      sbctl verify | grep Microsoft/Boot/systemd | awk '{print $2}' | xargs -L1 sbctl sign
    '';
    serviceConfig = {
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # systemd.services.dislocker = {
  #   path = [ pkgs.dislocker ];
  #   script = ''
  #     dislocker /dev/nvme0n1p3 -- /mnt/bitlocker
  #     /run/current-system/sw/bin/mount -o loop,rw,umask=0 /mnt/bitlocker/dislocker-file /mnt/c
  #   '';
  #   serviceConfig = {
  #       Type = "forking";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

  systemd.services.onedrive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=home/detroyejr/.config/rclone/rclone.conf
      mkdir -p /home/detroyejr/OneDrive/
      if test -f $FILE; then
        ${pkgs.rclone}/bin/rclone mount \
          "onedrive": "/home/detroyejr/OneDrive/" \
          --vfs-cache-mode writes \
          --vfs-cache-max-size 4G \
          --log-level INFO \
          --log-file /tmp/rclone-onedrive.log \
          --umask 022 \
          --allow-other \
          --config=$FILE
      fi
    '';
    wantedBy = [ "multi-user.target" ];

  };

  # systemd.services.google_drive = {
  #   path = [ pkgs.rclone ];
  #   script = ''
  #     FILE=home/detroyejr/.config/rclone/rclone.conf
  #     mkdir -p home/detroyejr/Google Drive/
  #     if test -f $FILE; then
  #       rclone \
  #         --vfs-cache-mode writes \
  #         --vfs-cache-max-size 4G \
  #         --log-level INFO \
  #         --log-file /tmp/rclone-google.log \
  #         --umask 022 \
  #         --allow-other \
  #         --config=$FILE mount \
  #         "Google Drive": "/home/detroyejr/Google Drive/"
  #     fi
  #   '';
  #   wantedBy = [ "multi-user.target" ];
  # };
  

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.11"; # Did you read the comment?
}

