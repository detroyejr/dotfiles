{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ rclone ];

  systemd.services.onedrive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p /home/detroyejr/OneDrive/
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
          "OneDrive:" "/home/detroyejr/OneDrive/"
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google_drive = {
    path = [ "${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p "/home/detroyejr/Google Drive"
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 20G \
          --dir-cache-time 5m0s \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-google.log \
          --umask 022 \
          --file-perms=0777 \
          --uid 1000 \
          --gid 1000 \
          --allow-other \
          --config=$FILE \
          "Google Drive:" "/home/detroyejr/Google Drive/"
      fi
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
