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
    rev = "b2fa6bb0d16c9afaaf808135820a64b240411df0";
    hash = "sha256-DkmkUHRSx+k+NQlXOqCVq0CT8F5ZclOyWTVrOhXOqeI=";
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
