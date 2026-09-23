{ config, lib, ... }:
let
  cfg = config.services.odpProxy;

  proxy = upstream: ssl: {
    forceSSL = true;
    sslCertificate = "/var/lib/odp-ca/edge.crt";
    sslCertificateKey = "/var/lib/odp-ca/edge.key";
    locations."/" = {
      proxyPass = upstream;
      proxyWebsockets = true;
      extraConfig = lib.optionalString ssl ''
        proxy_ssl_verify off;
      '';
    };
  };
in
{
  options.services.odpProxy.enable = lib.mkEnableOption "ODP reverse proxy";

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "actual.odp-1" = proxy "https://127.0.0.1:3000" true;
        "archivebox.odp-1" = proxy "https://192.168.1.14" true;
        "changedetection.odp-1" = proxy "http://127.0.0.1:5001" false;
        "freshrss.odp-1" = proxy "https://127.0.0.1:8443" true;
        "glance.odp-1" = proxy "http://odp-3:5678" false;
        "grafana.odp-1" = proxy "http://odp-2:3001" false;
        "immich.odp-1" = proxy "http://odp-5:2283" false;
        "logs.odp-1" = proxy "http://odp-2:3100" false;
        "opencode.odp-1" = proxy "http://odp-3:46279" false;
        "paperless.odp-1" = proxy "http://127.0.0.1:28981" false;
        "prometheus.odp-1" = proxy "http://odp-2:9090" false;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
