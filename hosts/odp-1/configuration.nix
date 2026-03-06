{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    bash.enable = true;
    cataclysmdda.enable = true;
    direnv.enable = true;
    firefox.enable = true;
    git.enable = true;
    hyprland.enable = true;
    neovim.enable = true;
    opencode.enable = true;
    python.enable = true;
    r.enable = true;
    steam.enable = true;
    thunar.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    actual.enable = true;
    binaryCache.enable = true;
    customWhisperServer.enable = true;
    freshrss.enable = true;
    glance.enable = true;
    grafana.enable = true;
    openrgb.enable = true;
    paperless.enable = true;
    prometheus.enable = true;
    rclone = {
      onedrive.enable = true;
      googleDrive.enable = true;
    };
    syncthing.enable = true;
    virtualization.enable = false;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
      authorizedKeysFiles = [
        "/home/detroyejr/.ssh/main_server_ed25519.pub"
      ];
    };

    opencode = {
      enable = true;
      passwordFile = config.sops.secrets."opencode/password".path;
    };
  };

  fileSystems."/run/mount/Media" = {
    device = "192.168.1.107:/mnt/nas0/Media";
    fsType = "nfs";
    options = [
      "rw"
      "relatime"
      "user"
    ];
  };

  sops.secrets = {
    "rootCA/ODPCA.crt" = {
      owner = "detroyejr";
      group = "nginx";
    };
    "rootCA/ODPCA.key" = {
      owner = "detroyejr";
      group = "nginx";
    };
    "rootCA/san.cnf" = {
      owner = "detroyejr";
      group = "nginx";
    };
    "opencode/password" = {
      owner = "detroyejr";
      group = "detroyejr";
    };
  };

  networking = {
    hostName = "odp-1";
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
    firewall = {
      allowedTCPPorts = [
        22
        80
        5678
        7878
        8000
        8080
        11434
      ];
      allowedUDPPorts = [ 53 ];
    };
  };

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    services.build-hook = {
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

    timers.build-hook = {
      timerConfig = {
        OnCalendar = "Mon,Wed,Fri *-*-* 22:00:00";
        Persistent = false;
      };
      wantedBy = [ "timers.target" ];
    };
  };

  system.stateVersion = "23.11";
}
