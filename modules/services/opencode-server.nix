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

      path =
        let
          opencode = inputs.opencode.outputs.packages.x86_64-linux.opencode.overrideAttrs (old: {
            postInstall = lib.optionalString (pkgs.stdenvNoCC.buildPlatform.canExecute pkgs.stdenvNoCC.hostPlatform) ''
              # trick yargs into also generating zsh completions
              installShellCompletion --cmd opencode \
                --bash <($out/bin/opencode --completions bash) \
                --zsh <(SHELL=/bin/zsh $out/bin/opencode --completions zsh)
            '';
          });
        in
        [
          opencode
        ];

      script = ''
        ${lib.optionalString (
          cfg.passwordFile != null
        ) "export OPENCODE_SERVER_PASSWORD=$(cat ${lib.escapeShellArg (toString cfg.passwordFile)})"}

        opencode serve --hostname 0.0.0.0 --port 46279 
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
