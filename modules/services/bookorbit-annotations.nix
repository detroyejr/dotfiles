{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bookorbitAnnotations;
in
{
  options.services.bookorbitAnnotations = {
    enable = lib.mkEnableOption "BookOrbit annotation sync to an Obsidian vault";

    vaultDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.defaultUser}/Documents/Obsidian";
      description = "Path to the Obsidian vault that receives generated book notes.";
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "*-*-* 0/2:00:00";
      description = "Systemd calendar expression for the sync timer.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "bookorbit/user" = {
        owner = config.defaultUser;
        group = config.defaultUser;
        mode = "0400";
      };
      "bookorbit/password" = {
        owner = config.defaultUser;
        group = config.defaultUser;
        mode = "0400";
      };
    };

    systemd.services.bookorbit-annotations = {
      description = "Sync BookOrbit annotations to the Obsidian vault";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = with pkgs; [
        coreutils
        curl
        gnused
        jq
      ];
      script = ''
        BOOKORBIT_USERNAME="$(< ${config.sops.secrets."bookorbit/user".path})" \
        BOOKORBIT_PASSWORD="$(< ${config.sops.secrets."bookorbit/password".path})" \
          ${pkgs.bash}/bin/bash ${../../dotfiles/bookorbit-annotations} ${lib.escapeShellArg cfg.vaultDirectory}
      '';
      serviceConfig = {
        Type = "oneshot";
        User = config.defaultUser;
        Group = config.defaultUser;
      };
    };

    systemd.timers.bookorbit-annotations = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
      };
    };
  };
}
