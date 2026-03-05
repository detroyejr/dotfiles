{
  config,
  lib,
  ...
}:
let
  cfg = config.services.syncthing;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      user = lib.mkDefault "detroyejr";
      dataDir = lib.mkDefault "/home/detroyejr/Documents";
      configDir = lib.mkDefault "/home/detroyejr/.config/syncthing";
    };

    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 ];
  };
}
