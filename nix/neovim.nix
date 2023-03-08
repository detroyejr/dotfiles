{ pkgs, lib, ... }:
{
  home.file."/home/detroyejr/.config/nvim" = {
    source = ../nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    xclip
  ];
}
