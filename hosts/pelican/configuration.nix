{
  pkgs,
  lib,
  config,
  ...
}:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "pelican";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = lib.mkDefault true;
  };

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            label = "boot";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          nixos = {
            name = "nixos";
            label = "nixos";
            end = "-8G";
            content = {
              type = "luks";
              name = "nixos";
              settings.allowDiscards = true;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
          swap = {
            name = "swap";
            label = "swap";
            size = "100%";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
        };
      };
    };
  };

  programs = {
    cataclysmdda.enable = true;
    firefox.enable = true;
    git.enable = true;
    hyprland.enable = true;
    neovim.enable = true;
    opencode.enable = true;
    steam.enable = true;
    thunar.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

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

  users.users.${config.defaultUser}.packages = with pkgs; [
    anki
    discord
    element-desktop
    hyperion-ng
    libreoffice
    nfs-utils
    obsidian
    plex-desktop
    plex-htpc
    plexamp
    vlc
    yt-dlp
  ];

  system.stateVersion = "25.05";
}
