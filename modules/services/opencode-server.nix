{
  inputs,
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

      path = [
        inputs.opencode.outputs.packages.x86_64-linux.opencode
      ];

      script = ''
        ${lib.optionalString (
          cfg.passwordFile != null
        ) "export OPENCODE_SERVER_PASSWORD=$(cat ${lib.escapeShellArg (toString cfg.passwordFile)})"}
        
        opencode serve --hostname 0.0.0.0 --port ${toString cfg.port} 
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
