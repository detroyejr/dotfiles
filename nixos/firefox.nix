{ pkgs, ... }:
let
  gwfox = pkgs.fetchFromGitHub {
    owner = "akkva";
    repo = "gwfox";
    rev = "ae6e7f097eb1db0a818e9eb15c114c69b4feb0c6";
    hash = "sha256-O/ooCZ4AzB8Qh7ludMYxR7Qv8LYLsy/mzBnJ3MFQ8c8=";
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    preferences = {
      "browser.tabs.allow_transparent_browser" = true;
      "browser.tabs.insertAfterCurrent" = true;
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
        export PROFILE=$(cat /home/detroyejr/.mozilla/firefox/profiles.ini | grep Path | cut -d= -f2)
        ln -sfn ${gwfox}/chrome /home/detroyejr/.mozilla/firefox/''${PROFILE}/chrome
      '';
    };
  };
}
