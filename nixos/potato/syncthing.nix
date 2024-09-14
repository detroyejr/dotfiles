{...}: {
  services.syncthing = {
    enable = true;
    user = "detroyejr";
    dataDir = "/home/detroyejr/Documents";
    configDir = "/home/detroyejr/.config/syncthing";
  };

  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000];
}
