{ pkgs, lib, ... }:

{

  networking = {
    hostName = "razorback";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = lib.mkForce false;
    firewall = {
      allowedTCPPorts = [ 51820 ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  services.resolved.enable = false;
  systemd.network = {
    enable = true;
    netdevs."50-tun1" = {
      netdevConfig = {
        Name = "tun1";
        Kind = "tun";
      };
    };
    networks."50-tun1" = {
      matchConfig.Name = "tun1";
      addresses = [
        {
          Address = "10.1.1.2/30";
          Peer = "10.1.1.1/30";
        }
      ];

      routes = [
        {
          Destination = "10.0.50.0/24";
          Gateway = "10.1.1.1";
        }
      ];
    };
    networks."10-end0" = {
      matchConfig.Name = "end0";
      address = [
        "192.168.1.160/24"
        "2600:4040:2484:b00:ba27:ebff:fe98:cb6f/64"
      ];
      routes = [
        { Gateway = "192.168.1.1"; }
        {
          Gateway = "fe80::ae91:9bff:fe03:2914";
          GatewayOnLink = true;
        }
      ];
    };
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "/etc/xdg";
  };

  programs = {
    git.enable = true;
    neovim.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  # Wireguard
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  environment.systemPackages = [
    pkgs.wireguard-tools
    pkgs.lshw
  ];

  systemd.services.wireguard = {
    path = [ "${pkgs.wireguard-tools}/bin:${pkgs.iproute2}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      #!/bin/env bash
      if [[ -z $(ip addr | grep wg0) ]]; then 
        wg-quick up wg0
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  users.users.detroyejr = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHghjAbyAv/H7wwS/UubXrqHsUMsMXrUaLl7E9ON/2jm detroyejr@pelican"
    ];
  };

  services = {
    alloy.enable = true;
    pihole.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitTunnel = true;
        X11Forwarding = true;
      };
    };
    fail2ban = {
      enable = true;
    };
  };

  system.stateVersion = "26.05";
}
