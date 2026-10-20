{ pkgs, ... }:
{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = [ "192.168.1.222" ];
  };

  systemd.services = {
    rustdesk-signal.environment = {
      ALWAYS_USE_RELAY = "Y";
      XDG_CONFIG_HOME = "/var/lib/rustdesk";
    };
    rustdesk-relay.environment.XDG_CONFIG_HOME = "/var/lib/rustdesk";

    rustdesk = {
      description = "RustDesk privileged desktop helper";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-user-sessions.service" ];
      path = with pkgs; [
        procps
        sudo
      ];
      environment = {
        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_RUNTIME_DIR = "/run/user/1000";
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        PULSE_LATENCY_MSEC = "60";
        PIPEWIRE_LATENCY = "1024/48000";
      };
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
        Restart = "on-failure";
        RestartSec = "5s";
        LimitNOFILE = 100000;
      };
    };
  };
}
