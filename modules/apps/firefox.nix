{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.firefox;
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
    "browser.startup.homepage" = "https://glance.odp-1";
    "browser.tabs.insertAfterCurrent" = true;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.placeholderName.private" = "DuckDuckGo";
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.usage.uploadEnabled" = false;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
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
  };
}
