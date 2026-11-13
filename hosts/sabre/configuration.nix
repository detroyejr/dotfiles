{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

{

  imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4 ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "sabre";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
    direnv.enable = true;
    firefox.enable = true;
    foot.enable = true;
    git.enable = true;
    neovim.enable = true;
    opencode.enable = true;
    tmux.enable = true;
    wireshark.enable = true;
    zsh.enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
    docker.enable = true;
    fprintd.enable = true;
    rclone = {
      onedrive.enable = true;
    };
    syncthing.enable = true;
    virtualization.enable = true;
  };

  users.users.${config.defaultUser}.packages = with pkgs; [
    anki
    discord
    element-desktop
    hyperion-ng
    keepass
    libreoffice
    nfs-utils
    obsidian
    plex-desktop
    plex-htpc
    plexamp
    windows95-kde-theme
    vlc
    yt-dlp
  ];

  system.stateVersion = "26.05";
}
