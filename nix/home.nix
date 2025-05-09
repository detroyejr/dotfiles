{ ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "detroyejr";
  home.homeDirectory = "/home/detroyejr";
  programs.home-manager.enable = true;

  # NOTE: Disable during Source Hut outage.
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "$HOME/Downloads";
      documents = "$HOME/Documents";
      pictures = "$HOME/Documents/Pictures";
      videos = "$HOME/Documents/Videos";
    };
  };

  home.stateVersion = "23.11";
}
