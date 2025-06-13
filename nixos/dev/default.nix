{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./python.nix
    ./r.nix
  ];

  environment.systemPackages = with pkgs; [
    clang-tools
    code-cursor
    gcc
    lua-language-server
    nixd
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
