{ config, lib, ... }:
let
  cfg = config.services.bookorbit;
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "bookorbit/jwtSecret" = { };
      "bookorbit/podcastEncryptionKey" = { };
      "bookorbit/setupBootstrapToken" = { };
    };

    sops.templates."bookorbit.env".content = ''
      JWT_SECRET=${config.sops.placeholder."bookorbit/jwtSecret"}
      PODCAST_ENCRYPTION_KEY=${config.sops.placeholder."bookorbit/podcastEncryptionKey"}
      SETUP_BOOTSTRAP_TOKEN=${config.sops.placeholder."bookorbit/setupBootstrapToken"}
    '';

    services.bookorbit = {
      environmentFile = config.sops.templates."bookorbit.env".path;
      openFirewall = true;
      environment = {
        APP_URL = "https://bookorbit.odp-1";
        CLIENT_URL = "https://bookorbit.odp-1";
        LIBRARY_BROWSE_ROOT = "/var/lib/bookorbit/books";
        NODE_MAX_OLD_SPACE_SIZE = "2048";
        PORT = 3002;
        TZ = config.time.timeZone;
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/bookorbit/books 0755 ${cfg.user} ${cfg.group} -"
    ];
  };
}
