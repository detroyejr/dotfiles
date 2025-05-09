{ pkgs, ... }:
{
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

      export EDITOR=nvim

      if [ -d "$HOME/.local/bin/" ] ; then
          PATH="$HOME/.local/bin/:$PATH"
      fi

      if [ -d "$HOME/.local/bin/bash/" ] ; then
          PATH="$HOME/.local/bin/bash/:$PATH"
      fi

      # Yazi
      function ya() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      eval "$(direnv hook zsh)"
    '';
  };
}
