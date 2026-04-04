{ inputs, config, ... }:
{
  import = [ inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia ];

  networking.networkmanager.enable = true;
  networking.hostName = "scorpion";

  programs = {
    git.enable = true;
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

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  system.stateVersion = "23.11";
}
