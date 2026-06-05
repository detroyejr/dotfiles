{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia ];

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
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-hyperion
      ];
    };
    opencode.enable = true;
    python.enable = false;
    r.enable = false;
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
    docker.enable = true;
    hardware.openrgb.enable = true;
    rclone = {
      onedrive.enable = true;
    };
    syncthing.enable = true;
    fprintd.enable = true;
    libinput.touchpad.disableWhileTyping = true;
    tlp.enable = true;
    udev.packages = [ pkgs.rtl-sdr-librtlsdr ];
  };

  users.users.${config.defaultUser}.packages = with pkgs; [
    anki
    calibre
    chromium
    discord
    element-desktop
    hyperion-ng
    libreoffice
    lutris
    nfs-utils
    obsidian
    plex-desktop
    plex-htpc
    plexamp
    slack
    vlc
    yt-dlp
  ];

  system.stateVersion = "25.05";
}
