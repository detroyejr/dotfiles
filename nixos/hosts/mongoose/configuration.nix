{ pkgs, config, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../../apps/cataclysm-dda.nix
    ../../apps/fonts.nix
    ../../default.nix
    ../../services/syncthing.nix
  ];

  services.desktopManager.plasma6.enable = true;

  programs.firefox.enable = true;

  networking.hostName = "mongoose";
  services.xserver.enable = true;

  fileSystems."/home/detroyejr/SD" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-hyperion
      obs-pipewire-audio-capture
      wlrobs
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

  programs.steam = {
    enable = true;
    extest.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnutls
    heroic
    keepassxc
    plasmadeck-vapor-theme
    plex-htpc
    protonup-ng
    wezterm
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

  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.authorizedKeysFiles = [
    "/home/detroyejr/.ssh/main_server_ed25519.pub"
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/detroyejr/.steam/root/compatibilitytools.d";
  };

  # Set the theme.
  system.activationScripts = {
    nvimConfig = {
      text = ''
        ln -sfn ${../../../dotfiles/nvim/.} /home/detroyejr/.config/nvim
      '';
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.11";
}
