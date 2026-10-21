{ pkgs, ... }:
{
  imports = [
    ./foot.nix
    ./git.nix
    ./neovim.nix
    ./opencode.nix
    ./python.nix
    ./r.nix
    ./tmux.nix
    ./wezterm.nix
    ./yazi.nix
    ./zsh.nix
  ];

  environment.systemPackages = [ pkgs.python3 ];
}
