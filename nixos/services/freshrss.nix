{ config, ... }:
{

  sops.secrets."freshrss/password" = {
    owner = "freshrss";
    group = "freshrss";
  };

  sops.secrets."freshrss/sslCert" = {
    owner = "nginx";
    group = "nginx";
  };

  sops.secrets."freshrss/sslKey" = {
    owner = "nginx";
    group = "nginx";
  };

  services.freshrss = {
    enable = true;
    authType = "form";
    baseUrl = "http://odp-1";
    dataDir = "/var/lib/freshrss";
    passwordFile = config.sops.secrets."freshrss/password".path;

    # Enable API for mobile apps
    api.enable = true;
  };

  services.nginx.virtualHosts."freshrss" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."freshrss/sslCert".path;
    sslCertificateKey = config.sops.secrets."freshrss/sslKey".path;

    listen = [
      {
        addr = "0.0.0.0";
        port = 8443;
        ssl = true;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    (builtins.head config.services.nginx.virtualHosts."freshrss".listen).port
  ];
}
