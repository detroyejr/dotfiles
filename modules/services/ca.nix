{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.odpCA;
  caCertificate = config.sops.secrets."rootCA/ODPCA.crt".path;
  caKey = config.sops.secrets."rootCA/ODPCA.key".path;
  sanConfig = config.sops.secrets."rootCA/san.cnf".path;
  certificate = "/var/lib/odp-ca/edge.crt";
  key = "/var/lib/odp-ca/edge.key";
in
{
  options.services.odpCA.enable = lib.mkEnableOption "ODP certificate authority";

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "rootCA/ODPCA.crt" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "rootCA/ODPCA.key" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "rootCA/san.cnf" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/odp-ca 0750 root nginx -"
    ];

    systemd.services.odp-edge-certificate = {
      description = "Issue the ODP edge wildcard certificate";
      wantedBy = [ "multi-user.target" ];
      before = [ "nginx.service" ];
      path = with pkgs; [
        coreutils
        openssl
        systemd
      ];
      script = ''
        set -euo pipefail

        if test -s ${certificate} \
          && openssl x509 -checkend 2592000 -noout -in ${certificate} \
          && openssl verify -CAfile ${caCertificate} -verify_hostname glance.odp-1 ${certificate} >/dev/null; then
          exit 0
        fi

        workdir=$(mktemp -d)
        trap 'rm -rf "$workdir"' EXIT

        umask 077
        openssl genrsa -out "$workdir/edge.key" 4096
        openssl req \
          -new \
          -key "$workdir/edge.key" \
          -out "$workdir/edge.csr" \
          -config ${sanConfig} \
          -subj "/CN=odp-1"

        openssl x509 \
          -req \
          -in "$workdir/edge.csr" \
          -CA ${caCertificate} \
          -CAkey ${caKey} \
          -CAcreateserial \
          -CAserial "$workdir/ca.srl" \
          -out "$workdir/edge.crt" \
          -days 825 \
          -sha256 \
          -extfile ${sanConfig} \
          -extensions v3_req

        install -o root -g nginx -m 0640 "$workdir/edge.key" ${key}
        install -o root -g nginx -m 0644 "$workdir/edge.crt" ${certificate}

        if systemctl is-active --quiet nginx; then
          systemctl reload nginx
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    systemd.timers.odp-edge-certificate = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    systemd.services.nginx = {
      wants = [ "odp-edge-certificate.service" ];
      after = [ "odp-edge-certificate.service" ];
    };
  };
}
