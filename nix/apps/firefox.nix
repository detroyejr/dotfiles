{config, pkgs, ...}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  programs.chromium = {
    enable = true;
  };
}
