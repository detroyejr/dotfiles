{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./python.nix
    ./r.nix
  ];

  home.packages = with pkgs; [
    nil
    clang-tools
  ];
}
