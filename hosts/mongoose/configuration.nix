{ pkgs, config, ... }:
{

  networking.hostName = "mongoose";
  programs = {
    cataclysmdda.enable = true;
    firefox.enable = true;
    git.enable = true;
    neovim.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-hyperion
        obs-pipewire-audio-capture
        wlrobs
      ];
    };
    opencode.enable = true;
    steam = {
      enable = true;
      extest.enable = true;
    };
    tmux.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    flatpak.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
      authorizedKeysFiles = [ "/home/detroyejr/.ssh/main_server_ed25519.pub" ];
    };
    syncthing.enable = false;
  };

  fileSystems."/home/detroyejr/SD" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = config.defaultUser;
      desktopSession = "plasma";
    };
    devices = {
      steamdeck = {
        enable = true;
        autoUpdate = true;
      };
    };
    decky-loader = {
      enable = true;
      user = config.defaultUser;
      stateDir = "/var/lib/decky-loader";
    };
    steamos = {
      useSteamOSConfig = true;
      enableAutoMountUdevRules = true;
    };
    hardware.has.amd.gpu = true;
  };

  environment.systemPackages = with pkgs; [
    gnutls
    heroic
    keepassxc
    plasmadeck-vapor-theme
    plex-htpc
    protonup-ng
    (pkgs.makeDesktopItem {
      name = "Return to Gaming Mode";
      desktopName = "Return to Gaming Mode";
      exec = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout";
      icon = "steamdeck-gaming-return";
      terminal = false;
      type = "Application";
    })
    (pkgs.makeAutostartItem rec {
      name = "steam";
      package = pkgs.makeDesktopItem {
        inherit name;
        desktopName = "Steam";
        exec = "steam -silent %U";
        icon = "steam";
        extraConfig = {
          OnlyShowIn = "KDE";
        };
      };
    })
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/detroyejr/.steam/root/compatibilitytools.d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.11";
}
