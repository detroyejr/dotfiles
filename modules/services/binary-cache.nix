{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.binaryCache;
  cacheName = lib.removePrefix "odp-" config.networking.hostName;
in
{
  options.services.binaryCache.enable = lib.mkEnableOption "binary cache service module";

  config = lib.mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      package = pkgs.nix-serve-ng;
      secretKeyFile = "/home/detroyejr/.ssh/cache-private-key.pem";
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "cache.odp-${cacheName}" = {
          locations."/".proxyPass =
            "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.nginx.defaultHTTPListenPort ];
  };
}
