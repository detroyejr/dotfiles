{ pkgs, ... }:
{

  imports = [
    ../../../modules/theme.nix
    ../../services/binary-cache.nix
  ];

  nix = {
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
      randomizedDelaySec = "20min";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "http://odp-1.lan/?priority=10"
        "http://odp-2.lan/?priority=10"
        "http://odp-3.lan/?priority=10"
        "http://odp-4.lan/?priority=10"
        "http://odp-5.lan/?priority=10"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "odp-1.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "odp-2.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "odp-3.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "odp-4.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "odp-5.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
      ];

      trusted-users = [
        "root"
        "detroyejr"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.detroyejr = {
    isNormalUser = true;
    description = "Jonathan De Troye";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      neovim
      btop
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPq36MnanxkOnpsouHzkGJtudcEZ+00i202DVfUXycjT detroyejr@XPS-Nixos"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPq36MnanxkOnpsouHzkGJtudcEZ+00i202DVfUXycjT detroyejr@XPS-Nixos"
  ];

  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "24.11";
}
