{ pkgs, ... }:

let
  custom-scripts = pkgs.stdenv.mkDerivation {
    name = "custom-bash-scripts";
    version = "1.0";
    src = ../dotfiles/bash;
    hash = "";

    installPhase = ''
      mkdir -p $out/bin && cp -r . $out/bin
      find $out/bin -exec chmod +x {} \;
    '';
  };
in
{
  environment.systemPackages = [
    custom-scripts
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    shellAliases = {
      k = "kubectl";
      ll = "eza -l";
      ls = "eza";
      pwsh = "pwsh.exe";
      ssh = "TERM=xterm-256color ssh";
      st = "set-title";
      tf = "tmux-fzf";
      vim = "nvim";
      rm = "rm -I";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "tmux"
      ];
    };
    syntaxHighlighting.enable = true;
    shellInit = ''
      # ZSH Options
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $HOME/.p10k.zsh
      source ${custom-scripts}/bin/functions
      export EDITOR=nvim
      eval "$(direnv hook zsh)"
    '';
  };
}
