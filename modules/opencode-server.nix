{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.opencode;
in
{
  options = {
    services.opencode = {
      enable = lib.mkEnableOption "Opencode Web Server";
      user = lib.mkOption {
        type = lib.types.str;
        default = "opencode";
        description = ''
          User account under which Plex runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "opencode";
        description = ''
          Group under which Plex runs.
        '';
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 46279;
        description = ''
          The default port for the web server.
        '';
      };
      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the web server secret.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.opencode-web = {
      description = "Opencode Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        opencode
      ];

      script = ''
        ${lib.optionalString (
          cfg.passwordFile != null
        ) "export OPENCODE_SERVER_PASSWORD=$(cat ${lib.escapeShellArg (toString cfg.passwordFile)})"}

        opencode web --mdns --port ${toString cfg.port}
      '';

      serviceConfig = {
        Type = "simple";
        User = "detroyejr";
        Group = "detroyejr";
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
