{
  config,
  lib,
  ...
}:
let
  cfg = config.services.syncthing;
  devices = {
    longsword = {
      id = "RRNCNLA-7FFYLPN-25GRMGX-UKMNULH-F2UJFHX-2YGILB6-WSRSLEE-RIL3WAP";
    };
    odp-1 = {
      id = "BZIZSTG-AIJPERQ-H5PUBIO-63REQBG-FLDBJ2K-QD2LKE4-UASUYE2-KVB62AZ";
    };
    pelican = {
      id = "KNU5VRJ-VGAQKWB-2KNMUEG-DIYA6EL-D2G2LQS-OVU6Z6G-ZPO2AV5-6RUGYAQ";
    };
    sabre = {
      id = "BB5CM3Y-JRX56Z4-6FUR3X5-53RWV6C-ZCQIE2Z-T5WFI2R-BM2S4AD-FJ4JZQR";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      openDefaultPorts = true;
      key = config.sops.secrets."syncthing/${config.system.name}-key".path;
      cert = config.sops.secrets."syncthing/${config.system.name}-cert".path;
      relay.enable = true;
      settings = {
        inherit devices;
        folders = {
          "~/sync" = {
            id = "fccwj-dffex";
            name = "sync";
            devices = builtins.attrNames devices;
            ignorePerms = true;
            copyOwnershipFromParent = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      config.services.syncthing.relay.port
      config.services.syncthing.relay.statusPort
    ];

    systemd.services.syncthing = {
      serviceConfig = {
        AmbientCapabilities = "CAP_CHOWN";
        CapabilityBoundingSet = "CAP_CHOWN";
      };
    };

    system.activationScripts.syncthingPermissions = {
      text = ''
        mkdir -p /var/lib/syncthing/sync
        chown -R syncthing:syncthing /var/lib/syncthing/sync
        chmod -R 2770 /var/lib/syncthing
        ln -sfn /var/lib/syncthing/sync /home/${config.defaultUser}/Sync
      '';
    };

    sops.secrets = {
      "syncthing/${config.system.name}-key" = {
        owner = "syncthing";
        group = "syncthing";
      };
      "syncthing/${config.system.name}-cert" = {
        owner = "syncthing";
        group = "syncthing";
      };
    };
  };
}
