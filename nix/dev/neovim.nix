{ pkgs, lib, ... }:
{
  home.file.".config/nvim" = {
    source = ../../dotfiles/nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    xclip
  ];
}
