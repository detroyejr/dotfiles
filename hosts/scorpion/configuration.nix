{ pkgs, config, ... }:
{

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking.networkmanager.enable = true;
  networking.hostName = "scorpion";

  programs = {
    yazi.enable = true;
    zsh.enable = true;
  };

  services = {
    docker.enable = false;
    plex.enable = true;
    prometheus.enable = true;

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

  users.users.${config.defaultUser} = {
    isNormalUser = true;
    description = "Jonathan De Troye";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    home-manager
    nfs-utils
    nvtopPackages.full
  ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  system.stateVersion = "23.11";
}
