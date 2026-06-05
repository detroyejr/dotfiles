{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.rclone;
in
{
  options = {
    services.rclone = {
      onedrive.enable = lib.mkEnableOption "OneDrive rclone mount";
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.onedrive.enable [
      pkgs.rclone
    ];

    systemd.services.onedrive = lib.mkIf cfg.onedrive.enable {
      path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
      script = ''
        FILE=/etc/xdg/rclone/rclone.conf
        mkdir -p /home/${config.defaultUser}/OneDrive/
        if test -f $FILE; then
          sleep 20
          ${pkgs.rclone}/bin/rclone mount \
            --vfs-cache-mode full \
            --vfs-cache-max-size 10G \
            --dir-cache-time 10m0s \
            --default-permissions \
            --log-level INFO \
            --log-file /tmp/rclone-onedrive.log \
            --umask 022 \
            --uid 1000 \
            --gid 1000 \
            --file-perms=0777 \
            --allow-other \
            --config=$FILE \
            "OneDrive:" "/home/${config.defaultUser}/OneDrive/"
        fi
      '';
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.keypass-sync =
      lib.mkIf (lib.and cfg.onedrive.enable config.services.syncthing.enable)
        {
          path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
          script = ''
            FILE=/etc/xdg/rclone/rclone.conf
            if test -f $FILE; then

              ${pkgs.rclone}/bin/rclone \
                copyto \
                --update \
                --config=$FILE \
                "OneDrive:Apps/KeyPass/Personal_KeyPass.kdbx" \
                "/var/lib/syncthing/sync/Personal_KeyPass.kdbx "

              ${pkgs.rclone}/bin/rclone \
                copyto \
                --update \
                --config=$FILE \
                "/var/lib/syncthing/sync/Personal_KeyPass.kdbx" \
                "OneDrive:Apps/KeyPass/Personal_KeyPass.kdbx"
            fi
          '';
          wantedBy = [ "multi-user.target" "network-online.target" ];
          serviceConfig.Type = "oneshot";
          startAt = "hourly";
        };
  };
}
