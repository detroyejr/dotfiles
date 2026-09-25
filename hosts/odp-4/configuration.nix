{
  pkgs,
  config,
  lib,
  ...
}:

{
  networking.hostName = "odp-4";

  services = {
    alloy.enable = true;
    archivebox = {
      enable = true;
      hostName = "archivebox.odp-1";
    };
    binaryCache.enable = true;

    # Configure keymap in X11
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  programs = {
    yazi.enable = true;
    zsh.enable = true;
    tmux.enable = true;
  };

  # Hardware
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5e4937c2-2a8f-453a-9c3c-69b428090296";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/173F-3560";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.${config.defaultUser} = {
    isNormalUser = true;
    description = "Jonathan De Troye";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      neovim
      btop
      playwright-get-url
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPq36MnanxkOnpsouHzkGJtudcEZ+00i202DVfUXycjT detroyejr@XPS-Nixos"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPq36MnanxkOnpsouHzkGJtudcEZ+00i202DVfUXycjT detroyejr@XPS-Nixos"
  ];

  networking.firewall.enable = true;

  sops.secrets."freshrss/password" = {
    owner = "detroyejr";
    group = "detroyejr";
  };

  systemd = {
    services.archive-feeds = lib.mkIf config.services.archivebox.enable {
      path = with pkgs; [
        curl
        docker
        jq
        playwright-get-url
      ];
      script = ''
        playwright-get-url --wait 60 https://heidelblog.net,https://heidelblog.net/feed > /tmp/heidelnews.xml
        grep -Eo "https://heidelblog.net/[0-9]+/[0-9]+/[-a-zA-Z0-9]+/" /tmp/heidelnews.xml | uniq | head -n 20 > /tmp/heidelnews.txt
        docker cp /tmp/heidelnews.txt archivebox:/heidelnews.txt && rm /tmp/heidelnews.txt
        docker exec archivebox bash -c "
          cat /heidelnews.txt | \
          archivebox add \
            --only-new \
            --tag 'Theology'"

        # Modern Reformation
        playwright-get-url "https://modernreformation.org/resources" | \
          grep -oE '/resources/essays/[-a-zA-Z0-9]+' | \
          sort | \
          uniq | \
          xargs -I "{}" echo "https://modernreformation.org{}" > /tmp/modref.txt

        docker cp /tmp/modref.txt archivebox:/modref.txt && rm /tmp/modref.txt
        docker exec archivebox bash -c "
          cat /modref.txt | \
          archivebox add \
            --only-new \
            --tag 'Theology'"

        # Archive Favorites
        AUTH=$(
          curl -X POST -d "Email=admin&Passwd=$(cat /run/secrets/freshrss/password)" 'https://freshrss.odp-1/api/greader.php/accounts/ClientLogin' | \
          grep Auth | \
          sed 's/A/a/'
        )

        curl -s -H "Authorization:GoogleLogin $AUTH" \
          'https://odp-1:8443/api/greader.php/reader/api/0/stream/contents/user/-/state/com.google/starred?n=20' |
          jq -r '.items[].canonical.[].href' | \
          grep -Ev 'odp-4' > /tmp/favorites.txt

        docker cp /tmp/favorites.txt archivebox:/favorites.txt && rm /tmp/favorites.txt
        docker exec archivebox bash -c "
          cat /favorites.txt | \
          archivebox add \
            --only-new \
            --tag 'Favorites'"

      '';
      serviceConfig = {
        User = "root";
        Type = "oneshot";
      };
    };

    timers.archive-feeds = {
      timerConfig = {
        OnCalendar = "daily";
        Persistent = false;
      };
      wantedBy = [ "timers.target" ];
    };
  };

  system.stateVersion = "24.11";
}
