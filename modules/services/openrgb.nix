{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.openrgb;
  qmkDeviceSettings = pkgs.writeText "openrgb-qmk-devices.json" (
    builtins.toJSON {
      QMKOpenRGBDevices.devices = map (device: {
        name = device.name;
        usb_vid = device.usbVid;
        usb_pid = device.usbPid;
      }) cfg.qmkDevices;
    }
  );
in
{
  options.services.openrgb = {
    enable = lib.mkEnableOption "OpenRGB service module";

    qmkDevices = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "OpenRGB display name for the QMK device.";
            };

            usbVid = lib.mkOption {
              type = lib.types.str;
              description = "USB vendor ID in hexadecimal.";
            };

            usbPid = lib.mkOption {
              type = lib.types.str;
              description = "USB product ID in hexadecimal.";
            };
          };
        }
      );
      default = [ ];
      description = "QMK keyboards using the OpenRGB protocol.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb.enable = true;

    systemd.services.openrgb = lib.mkIf (cfg.qmkDevices != [ ]) {
      serviceConfig.ExecStart = lib.mkForce (
        lib.escapeShellArgs [
          (lib.getExe config.services.hardware.openrgb.package)
          "--server"
          "--server-port"
          (toString config.services.hardware.openrgb.server.port)
          "--localconfig"
        ]
      );

      preStart = ''
        set -eu
        config_file=/var/lib/OpenRGB/OpenRGB.json
        tmp_file="$(${pkgs.coreutils}/bin/mktemp "$config_file.tmp.XXXXXX")"
        trap '${pkgs.coreutils}/bin/rm -f "$tmp_file"' EXIT

        if [ -s "$config_file" ]; then
          ${pkgs.jq}/bin/jq --slurpfile qmk ${qmkDeviceSettings} '. * $qmk[0]' "$config_file" > "$tmp_file"
        else
          ${pkgs.coreutils}/bin/cp ${qmkDeviceSettings} "$tmp_file"
        fi

        ${pkgs.coreutils}/bin/chmod 0644 "$tmp_file"
        ${pkgs.coreutils}/bin/mv "$tmp_file" "$config_file"
      '';
    };
  };
}
