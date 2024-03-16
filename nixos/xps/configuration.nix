# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../default.nix
      ../../modules/fonts
      ../../modules/brightness
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "XPS-Nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;




  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  xdg.portal.config.common.default = "*";
  services = {
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    tlp.enable = true;
    tumbler.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "detroyejr";
      displayManager.gdm.enable = true;
      videoDrivers = [ "nvidia" ];
      libinput = {
        enable = true;
        touchpad = {
          scrollMethod = "twofinger";
          naturalScrolling = false;
        };
      };
    };
  };

  sound.enable = false;
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ [ "--enable-sixaxis" ];
      });
    };
    pulseaudio.enable = false;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.detroyejr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "input" "wireshark" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      git
      docker
      virtiofsd
      pulseaudioFull
      alsa-utils
    ];
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam-small.override
        {
          extraEnv = {
            __NV_PRIME_RENDER_OFFLOAD = 1;
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          };
        };
    };
    gamemode.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [ xfce.exo ];
    };
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  environment.systemPackages = with pkgs; [
    dislocker
    efibootmgr
    gcc
    heroic
    parted
    mangohud
    rclone
    sbctl
    usbutils
    wget
    wl-clipboard
  ];

  # For sway.
  security = {
    polkit.enable = true;
    pam.services.hyprlock.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth sufficient pam_unix.so   likeauth try_first_pass nullok
      auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11400)
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok sha512

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';
    pam.services.hyprlock.fprintAuth = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 51820 ];
  # networking.firewall.allowedUDPPorts = [ 80 443 51820 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  systemd.services.onedrive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p /home/detroyejr/OneDrive/
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 20G \
          --dir-cache-time 48h0m0s \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-onedrive.log \
          --umask 022 \
          --uid 1000 \
          --gid 1000 \
          --file-perms=0777 \
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
          --vfs-cache-max-size 30G \
          --dir-cache-time 48h0m0s \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-google.log \
          --umask 022 \
          --file-perms=0777 \
          --uid 1000 \
          --gid 1000 \
          --allow-other \
          --config=$FILE \
          "Google Drive:" "/home/detroyejr/Google Drive/"
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

