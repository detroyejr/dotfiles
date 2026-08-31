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
    rev = "b065dbffcb487c31f14ea9ba6c2d5c5f7e103727";
    hash = "sha256-7k2VsEzkO734KirvsBHSB1rzBS3DVtY94Pj0ZwPDknY=";
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
    "gwfox.blur" = true;
    "gwfox.bms" = true;
    "gwfox.icons" = true;
    "sidebar.main.tools" = "";
    "sidebar.verticalTabs" = true;
    "svg.context-properties.content.enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.rounded-bottom-corners.enabled" = true;
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
