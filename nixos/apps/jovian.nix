{ pkgs, ... }:
{
  # Jovian NixOS options, specific to the deck
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "detroyejr";
      desktopSession = "plasma";
    };
    devices = {
      steamdeck = {
        enable = true;
        autoUpdate = true;
      };
    };
    decky-loader = {
      enable = true;
      user = "detroyejr";
      stateDir = "/var/lib/decky-loader";
    };
    steamos = {
      useSteamOSConfig = true;
      enableAutoMountUdevRules = true;
    };
    hardware.has.amd.gpu = true;
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    plasmadeck-vapor-theme
    protonup-ng
    gnutls
    (pkgs.makeDesktopItem {
      name = "Return to Gaming Mode";
      desktopName = "Return to Gaming Mode";
      exec = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout";
      icon = "steamdeck-gaming-return";
      terminal = false;
      type = "Application";
    })
    (pkgs.makeAutostartItem rec {
      name = "steam";
      package = pkgs.makeDesktopItem {
        inherit name;
        desktopName = "Steam";
        exec = "steam -silent %U";
        icon = "steam";
        extraConfig = {
          OnlyShowIn = "KDE";
        };
      };
    })
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/detroyejr/.steam/root/compatibilitytools.d";
  };

}
