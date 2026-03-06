{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.zsh;

  custom-scripts = pkgs.stdenv.mkDerivation {
    name = "custom-bash-scripts";
    version = "1.0";
    src = ../../dotfiles/bash;
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
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enableCompletion = true;
      autosuggestions.enable = true;
      shellAliases = {
        ask = "opencode --agent research run";
        btop = "btop --config ${btop-conf}";
        k = "kubectl";
        ll = "eza -l";
        ls = "eza";
        pwsh = "pwsh.exe";
        rm = "rm -I";
        ssh = "TERM=xterm-256color ssh";
        st = "set-title";
        tf = "tmux-fzf";
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
      gcc
      gh
      jq
      just
      kubectl
      lsof
      nitch
      ollama
      openssh
      qsv
      tree
      unzip
      wget
      xclip
      yt-dlp
    ];

    environment.sessionVariables = {
      MANPAGER = "nvim +Man!";
    };
  };
}
