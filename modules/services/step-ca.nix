{
  config,
  lib,
  ...
}:
let
  cfg = config.services.step-ca;
in
{
  config = lib.mkIf cfg.enable {
    services.step-ca = {
      address = "[::]";
      port = 443;
      openFirewall = true;
      settings = {
        address = ":443";
        authority = {
          policy.x509.allow.dns = [
            "odp-1"
            "odp-2"
            "odp-3"
            "odp-4"
            "odp-5"
          ];

          provisioners = [
            {
              type = "ACME";
              name = "acme";
            }
          ];
        };
        crt = ../../dotfiles/ca/ca.crt;
        db = {
          badgerFileLoadingMode = "";
          dataSource = "/var/lib/step-ca/db";
          type = "badgerv2";
        };
        dnsNames = [
          "odp-1"
          "odp-2"
          "odp-3"
          "odp-4"
          "odp-5"
        ];
        federatedRoots = null;
        insecureAddress = "";
        key = config.sops.secrets."rootCA/ODPCA.key".path;
        logger = {
          format = "text";
        };
        root = ../../dotfiles/ca/ca.crt;
        tls = {
          cipherSuites = [
            "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
          ];
          maxVersion = 1.3;
          minVersion = 1.2;
          renegotiation = false;
        };
      };
    };
    sops.secrets = {
      "rootCA/ODPCA.crt" = {
        owner = "step-ca";
        group = "step-ca";
      };
      "rootCA/ODPCA.key" = {
        owner = "step-ca";
        group = "step-ca";
      };
    };
  };
}
