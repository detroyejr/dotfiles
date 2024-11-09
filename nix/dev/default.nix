{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./python.nix
    ./r.nix
  ];

  home.packages = with pkgs; [
    gcc
    clang-tools
    nil
  ];
}
