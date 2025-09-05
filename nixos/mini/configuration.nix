{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../actual.nix
    ../binary-cache.nix
    ../brightness.nix
    ../custom-whisper-server.nix
    ../cataclysm-dda.nix
    ../devices.nix
    ../fonts.nix
    ../hyprland.nix
    ../openrgb.nix
    ../rclone.nix
    ../sops.nix
    ../steam.nix
    ../syncthing.nix
    ../thunar.nix
    # ../veikk.nix
    ../virtualization.nix
  ];

  networking.hostName = "mini-1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.authorizedKeysFiles = [
    "/home/detroyejr/.ssh/main_server_ed25519.pub"
  ];

  fileSystems."/run/mount/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = [
      "rw"
      "relatime"
      "user"
    ];
  };

  networking = {
    networkmanager.enable = lib.mkForce false;
    wireless.enable = false;
    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.222";
          prefixLength = 24;
        }
      ];
      useDHCP = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    5678
    7878
    8000
    8080
    11434
  ];
  networking.firewall.allowedUDPPorts = [
    53
  ];

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  systemd.services.build-hook = {
    path = with pkgs; [
      bash
      gh
      git
      just
      nixos-rebuild
      nmap
      openssh
    ];
    script = ''
      gh workflow run --repo detroyejr/dotfiles flake.yml

      export ISDENIED=$(
        ncat -l 0.0.0.0 \
          --allow 192.30.252.0/22,185.199.108.0/22,140.82.112.0/20,143.55.64.0/20 \
          -p 7878 \
          -c "echo -e \"HTTP/1.1 204 No Content\\r\\nConnection: close\\r\\n\\r\"" \
          -v 2>&1 | grep 'denied: not allowed'
      )

      if [ -z "$DENIED" ]; then
        cd /home/detroyejr/.config/dotfiles && \
          eval $(ssh-agent) && \
          ssh-add /home/detroyejr/.ssh/github_rsa && \
          just ci
      fi

      echo "Done!"
    '';
    serviceConfig = {
      User = "root";
      Type = "oneshot";
    };
  };

  systemd.timers.build-hook = {
    timerConfig = {
      OnCalendar = "Mon,Wed,Fri *-*-* 22:00:00";
      Persistent = false;
    };
    wantedBy = [ "timers.target" ];
  };
  system.stateVersion = "23.11";
}
