{ pkgs, lib, ...}: 
{
  home.packages = with pkgs; [
    rustc
    cargo
    bat
    ripgrep
    exa
    dogdns
  ];

  programs.zsh.shellAliases = {
    ls = "exa";
  };
}
