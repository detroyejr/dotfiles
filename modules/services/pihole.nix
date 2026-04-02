{ lib, config, ... }:
let
  cfg = config.services.pihole;
in
{

  options.services.pihole = {
    enable = lib.mkEnableOption "Enable pihole-ftl and pihole-web";
  };

  config = lib.mkIf cfg.enable {
    users.users.pihole = {
      group = "pihole";
      # TODO: is gamemode needed?
      extraGroups = [
        "wheel"
      ];
    };
    users.groups.pihole = { };

    systemd.tmpfiles.rules = [
      "d /run/pihole 0755 pihole pihole - -"
      "f /run/pihole-FTL.pid 0644 pihole pihole - -"
      "f /run/pihole-FTL.port 0644 pihole pihole - -"
    ];

    services.pihole-ftl = {
      enable = true;
      openFirewallDNS = true;
      openFirewallWebserver = true;
      openFirewallDHCP = true;
      lists = [
        {
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
          type = "block";
          enabled = true;
          description = "Sample blocklist by hagezi";
        }
        {
          url = "https://v.firebog.net/hosts/AdguardDNS.txt";
          type = "block";
          enabled = true;
        }
        {
          url = "https://v.firebog.net/hosts/Easylist.txt";
          type = "block";
          enabled = true;
        }
        {
          url = "https://raw.githubusercontent.com/Sekhan/TheGreatWall/master/TheGreatWall.txt";
          type = "block";
          enabled = true;
        }
      ];
      settings = {
        dns = {
          interface = "end0";
          ignoreLocalhost = true;
          domainNeeded = true;
          expandHosts = true;
          upstreams = [
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
          ];
          hosts = [
            "192.168.1.1 router.asus.com"
            "192.168.1.158 pi3"
            "192.168.1.58 MainServer"
            "192.168.1.107 Proxmox"
            "192.168.1.55 pi4"
            "192.168.1.222 odp-1"
            "192.168.1.32 odp-2"
            "192.168.1.229 odp-3"
            "192.168.1.14 odp-4"
            "192.168.1.251 odp-5"
            "192.168.1.108 scorpion"
            "107.152.96.161 resources.zune.net"
          ];
          reply.host = {
            force4 = true;
            IPv4 = "192.168.1.160";
          };
          rateLimit.count = 5000;
        };
        dhcp = {
          interface = "end0";
          active = true;
          start = "192.168.1.2";
          end = "192.168.1.254";
          router = "192.168.1.1";
          leaseTime = "24h";
          ipv6 = true;
          rapidCommit = true;
          multiDNS = true;
          hosts = [
            "00:1C:C0:8F:63:30,192.168.1.107,MainServer"
            "D0:37:45:A7:93:7B,192.168.1.108,Brick"
          ];
        };
        webserver = {
          domain = "pi.hole";
          tls = {
            cert = lib.mkForce "/var/lib/pihole/pihole.pem";
          };
        };
        resolver = {
          refreshNames = "ALL";
        };
        database = {
          DBimport = true;
          DBinterval = 60;
          forceDisk = true;
          maxDBdays = 365;
        };
        misc.readOnly = false;
      };
      useDnsmasqConfig = true;
    };

    services.pihole-web.enable = true;
    services.pihole-web.hostName = "pi.hole";
    services.pihole-web.ports = [
      "80r"
      "443s"
    ];

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };

  };
}
