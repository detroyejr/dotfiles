{config, pkgs, ...}:
let
    chromium = pkgs.makeDesktopItem {
      name = "chromium";
      desktopName = "Chromium (web browser)";
      exec = "${pkgs.chromium}/bin/chromium --ozone-platform-hint=auto";
    };

    slack = pkgs.makeDesktopItem {
      name = "slack";
      desktopName = "slack";
      exec = "${pkgs.slack}/bin/slack --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto --ozone-platform=wayland -s %U";
    };
    
    plex-media-player = pkgs.makeDesktopItem {
      name = "plex";
      desktopName = "Plex Media Player (Media Player)";
      exec = "${pkgs.plex-media-player}/bin/plexmediaplayer --ozone-platform-hint=auto";
    };
    
    plexamp = pkgs.makeDesktopItem {
      name = "plexamp";
      desktopName = "plexamp";
      exec = "${pkgs.plexamp}/bin/plexamp --ozone-platform-hint=auto";
    };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  programs.chromium = {
    enable = true;
    package = chromium;
  };

  home.packages = [
    slack
    plex-media-player
    plexamp
  ];
}
