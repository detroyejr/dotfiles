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

  btop-conf = pkgs.writeTextFile {
    name = "btop.conf";
    text = ''
      color_theme = "TTY" 
      vim_keys = True
    '';
  };

in
{
  # Packages that should be installed to the user profile.
  environment.systemPackages = with pkgs; [
    awscli2
    bat
    bc
    btop
    curl
    custom-scripts
    eza
    fastfetch
    fd
    ffmpeg
    file
    fzf
    gh
    jq
    just
    kubectl
    lsof
    nitch
    nixfmt-rfc-style
    ollama
    openssh
    qsv
    ripgrep
    tree
    unzip
    wget
    xclip
    yazi
    yt-dlp
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
      rm = "rm -I";
      btop = "btop --config ${btop-conf}";
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
      eval "$(direnv hook zsh)"
    '';
  };

  environment.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };
}
