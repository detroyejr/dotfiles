{ pkgs, lib, ...}: 
{
  home.packages = with pkgs; [
    bat
    cargo
    dogdns
    exa
    ripgrep
    rustc
  ];

  programs.zsh.shellAliases = {
    ls = "exa";
  };
}
