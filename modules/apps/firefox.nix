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
      autoConfig = ''
        pref("general.config.filename", "firefox.cfg");
        pref("general.config.obscure_value", 0);
        pref("gwfox.plus", 1);
      '';
      policies = {
        GenerativeAI = {
          Enabled = false;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = false;
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          Stories = false;
          SponsoredPocket = false;
          SponsoredStories = false;
          Snippets = false;
          Locked = false;
        };
      };
      preferences = {
        "browser.ai.control.default" = "blocked";
        "browser.ml.enable" = false;
        "browser.startup.homepage" = "http://odp-1:5678";
        "browser.tabs.allow_transparent_browser" = true;
        "browser.tabs.insertAfterCurrent" = true;
        "sidebar.animation.enabled" = false;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.macos.titlebar-blend-mode.behind-window" = true;
        "widget.transparent-windows" = true;
        "widget.windows.mica" = true;
        "widget.windows.mica.extra" = true;
        "widget.windows.mica.popups" = 2;
        "widget.windows.mica.toplevel-backdrop" = 2;
        # FIXME: These don't apply.
        # "sidebar.verticalTabs" = true;
        # "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
      };
    };

    # Set the theme.
    system.activationScripts = {
      firefoxTheme = {
        deps = [ "specialfs" ];
        text = ''
          mkdir -p /home/${config.defaultUser}/.mozilla/firefox \
            && chown -R ${config.defaultUser} /home/${config.defaultUser}/.mozilla/firefox

          if [[ -n /home/${config.defaultUser}/.mozilla/firefox/profiles.ini ]]; then
            PROFILE=$(grep "Path=.*.default" /home/${config.defaultUser}/.mozilla/firefox/profiles.ini | cut -d= -f2)
            ln -sfn ${gwfox}/chrome /home/${config.defaultUser}/.mozilla/firefox/''${PROFILE}/chrome
          fi
        '';
      };
    };
  };
}
