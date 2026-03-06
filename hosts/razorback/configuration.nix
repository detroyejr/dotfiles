{ pkgs, lib, ... }:

{

  networking = {
    hostName = "razorback";
    useDHCP = false;
    wireless.enable = lib.mkForce false;
    defaultGateway = "192.168.1.1";
    defaultGateway6 = {
      address = "fe80::ae91:9bff:fe03:2914";
      interface = "end0";
    };
    interfaces.end0 = {
      ipv4 = {
        addresses = [
          {
            address = "192.168.1.160";
            prefixLength = 24;
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2600:4040:2484:b00:ba27:ebff:fe98:cb6f";
            prefixLength = 64;
          }
        ];
      };
    };
    firewall = {
      allowedTCPPorts = [ 51820 ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "/etc/xdg";
  };

  programs = {
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBl7Fld1yz1/LCajyuiSUKba9eiBRjvTmTMxCC0e+2MWNk3ZCnLkMWIigGPAKuxpHilc5bt21VwKlZ+sLPuQe8YYeU3MkVt/0+L4Jd5AYWBAQv9UPAmCdSUdN3XpwgH9qJQw/MaoTloHeBzUK9W1ruK91g9AQ+7+AHp7E+S0UaTGOssrMv0SE7OamLZQ8qR7X+lSfI9ZCFSBBzLeOoCOfTZShexrGrwTYgAdx/dYAgJVCAVQPPQ6OhL2W/mAqh8wI6w0jA0TwSOHvCiv2/ocV9O2BtRyoeANBsSu8S/J49nx5ja/+PMHFcoJZSCURnkWjtmybCDmIEa5YGX14PjHmPs4Xlb+iEXsnog1aaHS9wDKE+vO2HVZJ8NaJfG0E6hBbxNx165vsZjWAxgmiY6oNUiXp+CDAhLlwso457AeJQEn0XpSnw1EVeWX0SNZ7V2gNz9oadC9bhS7SMZ9SS6hkJrlkw4aISmSJqtzQffJzjRPOQct/QXmxuJ2jOqf98PzE= jon@DESKTOP-73M5KKL"
    ];
  };

  services = {
    pihole.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
    };
    fail2ban = {
      enable = true;
    };
  };

  system.stateVersion = "26.05";
}
