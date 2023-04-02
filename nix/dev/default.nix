{config, pkgs, ...}:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./python.nix
    ./r.nix
  ];
}
