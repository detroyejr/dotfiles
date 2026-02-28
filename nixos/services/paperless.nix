{ config, ... }:
{
  sops.secrets."paperless/password" = {
    owner = "detroyejr";
    group = "detroyejr";
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    user = "detroyejr";
    passwordFile = config.sops.secrets."paperless/password".path;
  };

  networking.firewall.allowedTCPPorts = [ config.services.paperless.port ];
}
