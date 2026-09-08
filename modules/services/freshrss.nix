{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.freshrss;

  llmClassification = pkgs.stdenvNoCC.mkDerivation {
    pname = "freshrss-extension-llm-classification";
    version = "0.3";

    src = pkgs.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "Extensions";
      rev = "30deb1664311febf9efb610a5db7c8fc1f9f86f8";
      hash = "sha256-0PxFDgHdF6GBh8dNdG4ga5ogmVb2cfW+mvuTVU8j3QA=";
    };

    sourceRoot = "source/xExtension-LlmClassification";

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/freshrss/extensions/xExtension-LlmClassification"
      cp -r . "$out/share/freshrss/extensions/xExtension-LlmClassification/"
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "FreshRSS extension that classifies articles with an OpenAI-compatible LLM API";
      homepage = "https://github.com/FreshRSS/Extensions/tree/main/xExtension-LlmClassification";
      license = licenses.agpl3Only;
      platforms = platforms.all;
    };
  };
in
{
  config = lib.mkIf cfg.enable {

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
      authType = "form";
      baseUrl = "http://odp-1";
      dataDir = "/var/lib/freshrss";
      passwordFile = config.sops.secrets."freshrss/password".path;

      extensions = [ llmClassification ];

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
  };
}
