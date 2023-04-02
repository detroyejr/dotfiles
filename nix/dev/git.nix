{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName  = "detroyejr";
    userEmail = "detroyejr@outlook.com";
  };

  programs.lazygit.enable = true;
}
