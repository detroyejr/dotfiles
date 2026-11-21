{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.immich;
  favoritesSyncCfg = config.services.immichFavoritesSync;
  syncScript = pkgs.writeShellApplication {
    name = "immich-favorites-sync";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gnugrep
      jq
      rclone
    ];
    text = builtins.readFile ../../dotfiles/immich-favorites-sync;
  };
in
{
  options.services.immichFavoritesSync = {
    enable = lib.mkEnableOption "sync Immich favorite images to an rclone destination";

    immichApiUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:2283/api";
      description = "Base URL for the Immich API, without a trailing slash.";
    };

    destination = lib.mkOption {
      type = lib.types.str;
      default = "PixStar:/pixstar/inbox";
      description = "rclone destination for favorite images.";
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = "Systemd calendar expression for the sync timer.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.immich = {
        openFirewall = true;
        host = "0.0.0.0";
      };
      services.postgresql = {
        package = pkgs.postgresql_18;
      };
    })
    (lib.mkIf favoritesSyncCfg.enable {
      sops.secrets."immich-kiosk/api-key" = { };

      systemd.services.immich-favorites-sync = {
        description = "Sync Immich favorite images to the Pixar rclone remote";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        environment = {
          IMMICH_API_URL = favoritesSyncCfg.immichApiUrl;
          RCLONE_CONFIG = "/etc/xdg/rclone/rclone.conf";
          RCLONE_DESTINATION = favoritesSyncCfg.destination;
        };
        serviceConfig = {
          Type = "oneshot";
          User = config.defaultUser;
          Group = config.defaultUser;
          LoadCredential = [
            "immich_api_key:${config.sops.secrets."immich-kiosk/api-key".path}"
          ];
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
        };
        path = [ syncScript ];
        script = "${syncScript}/bin/immich-favorites-sync";
      };

      systemd.timers.immich-favorites-sync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = favoritesSyncCfg.schedule;
          Persistent = true;
        };
      };
    })
  ];
}
