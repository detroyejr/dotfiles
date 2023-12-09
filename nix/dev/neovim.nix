{ pkgs, colorSchemeName, ... }:
{
  home.file.".config/nvim" = {
    source = ../../dotfiles/nvim;
    recursive = true;
  };

  home.file.".config/nvim/lua/user/colorscheme.lua".text = with colorSchemeName; ''
    vim.cmd[[colorscheme ${colorSchemeName}]]
  '';

  programs.neovim = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    nixd
    stylua
  ];
}
