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
    rev = "de0aed94ea4ff0dfc99b49d9457e470685e00742";
    hash = "sha256-hQWcMDYVTpz7bKqy7WyjpwDNBUxLAw2nB2DUvN5xwMQ=";
  };
  preferenceStr =
    preferences:
    lib.concatLines (
      lib.mapAttrsToList (
        key:
        (
          value:
          "pref(\"${key}\", ${
            if (builtins.isBool value) then
              lib.boolToString value
            else if (builtins.isInt value) then
              toString value
            else
              "\"${value}\""
          });"
        )
      ) preferences
    );
  preferences = {
    "browser.ai.control.default" = "blocked";
    "browser.link.open_newwindow" = 3;
    "browser.ml.enable" = false;
    "browser.nova.enabled" = false;
    "browser.newtabpage.activity-stream.nova.enabled" = false;
    "browser.newtabpage.activity-stream.showWeather" = false;
    "browser.startup.homepage" = "http://odp-1:5678";
    "browser.tabs.insertAfterCurrent" = true;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.placeholderName.private" = "DuckDuckGo";
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.usage.uploadEnabled" = false;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "gwfox.ac" = true;
    "gwfox.atbc" = true;
    "gwfox.blur" = true;
    "gwfox.bms" = true;
    "gwfox.icons" = true;
    "gwfox.fsi" = true;
    "gwfox.msc" = true;
    "gwfox.mwc" = true;
    "gwfox.newtab" = true;
    "gwfox.noborder" = true;
    "gwfox.sidebar" = 1;
    "gwfox.toolbar" = true;
    "gwfox.urlbar" = true;
    "gwfox.urlbar.ac" = true;
    "sidebar.main.tools" = "";
    "sidebar.verticalTabs" = true;
    "svg.context-properties.content.enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.rounded-bottom-corners.enabled" = true;
    "widget.macos.native-context-menus" = false;
    "widget.windows.mica" = true;
    "widget.windows.mica.toplevel-backdrop" = 2;
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      autoConfig = preferenceStr preferences;
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
      preferences = preferences;
    };

    environment.sessionVariables = {
      BROWSER = "firefox";
    };

    # Set the theme.
    system.activationScripts = {
      firefoxTheme = {
        deps = [ "specialfs" ];
        text = ''
          mkdir -p /etc/xdg/mozilla/firefox \
            && chown -R ${config.defaultUser} /etc/xdg/mozilla/firefox

          cat <<EOF >> /etc/xdg/mozilla/firefox/profiles.ini
            [Profile0]
            Name=default
            IsRelative=1
            Path=d3cgob0q.default
            Default=1

            [General]
            StartWithLastProfile=1
            Version=2
          EOF

          rm -rf /etc/xdg/mozilla/firefox/d3cgob0q.default/chrome && \
            mkdir -p /etc/xdg/mozilla/firefox/d3cgob0q.default/chrome && \
            ln -sfn ${gwfox}/*.css /etc/xdg/mozilla/firefox/d3cgob0q.default/chrome

          chown -R ${config.defaultUser} /etc/xdg/mozilla/firefox
        '';
      };
    };
  };
}
