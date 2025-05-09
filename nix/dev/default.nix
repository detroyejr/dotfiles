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

  programs.direnv.enable = true;
  programs.direnv.silent = true;
  programs.direnv.nix-direnv.enable = true;
}
