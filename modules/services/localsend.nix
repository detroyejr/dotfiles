{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.localsend-cli;
in
{
  options.services.localsend-cli.enable = lib.mkEnableOption "LocalSend CLI service";

  config = lib.mkIf cfg.enable {
    systemd.services.localsend-cli = {
      description = "LocalSend CLI daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        # The CLI enables raw terminal mode at startup, even when running as a
        # daemon. Give it a private PTY so systemd's non-terminal stdin does
        # not make it exit with ENXIO.
        ExecStart = "${pkgs.util-linux}/bin/script --quiet --return --command ${pkgs.localsend-cli}/bin/localsend-cli /dev/null";
        User = config.defaultUser;
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
}
