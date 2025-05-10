{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./python.nix
    ./r.nix
  ];

  environment.systemPackages = with pkgs; [
    nil
    clang-tools
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
