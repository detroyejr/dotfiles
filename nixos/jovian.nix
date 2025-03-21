{ ... }:
{
  # Jovian NixOS options, specific to the deck
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "detroyejr";
      desktopSession = "hyprland";
    };
    devices = {
      steamdeck = {
        enable = true;
        # enableGyroDsuService = true;
      };
    };
    decky-loader = {
      enable = true;
      user = "detroyejr";
      stateDir = "/var/lib/decky-loader";
    };
    steamos = {
      useSteamOSConfig = true;
    };
  };
}
