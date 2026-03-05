{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.firefox;
  gwfox = pkgs.fetchFromGitHub {
    owner = "akkva";
    repo = "gwfox";
    rev = "ba265484492b2f173f5d638e0170301130600a9b";
    hash = "sha256-bawCWWhgbP++n1X1805vcjSJJ4SUaYjmazbZgPcHM6k=";
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      preferences = {
        "browser.ml.enable" = false;
        "browser.tabs.allow_transparent_browser" = true;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.startup.homepage" = "http://odp-1:5678";
        "gwfox.plus" = true;
        "sidebar.animation.enabled" = false;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.macos.titlebar-blend-mode.behind-window" = true;
        "widget.transparent-windows" = true;
        "widget.windows.mica" = true;
        "widget.windows.mica.extra" = true;
        "widget.windows.mica.popups" = 2;
        "widget.windows.mica.toplevel-backdrop" = 2;
      };
    };

    # Set the theme.
    system.activationScripts = {
      firefoxTheme = {
        deps = [ "specialfs" ];
        text = ''
          export PROFILE=$(cat /home/${config.defaultUser}/.mozilla/firefox/profiles.ini | grep Path | cut -d= -f2)
          ln -sfn ${gwfox}/chrome /home/${config.defaultUser}/.mozilla/firefox/''${PROFILE}/chrome
        '';
      };
    };
  };
}
