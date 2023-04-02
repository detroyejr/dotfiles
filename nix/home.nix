{ config, pkgs, dotfiles, ... }:

let 
  oh-my-tmux = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf";
    sha256 = "sha256-E2e/v9Dn4Q6uFl/mLuSNyPntLciTc3QbYVtc71yW2BI=";
  };
in 
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.home-manager.enable = true;
  home.username = "detroyejr";
  home.homeDirectory = "/home/detroyejr";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    audible-cli
    awscli
    bc
    cmake
    curl
    ffmpeg
    fzf
    gcc
    gnumake
    jq
    kubectl
    lame
    mediainfo
    mitmproxy
    mp4v2
    neofetch
    nitch
    openssh
    ranger
    unzip
    wget
    yt-dlp
    zk
    zsh-powerlevel10k
  ];
  
  programs.bash.enable = true;

  # Theme for Powerlevel10k.
  home.file.".p10k.zsh".source = ../dotfiles/zsh/.p10k.zsh;
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      export PATH=$PATH:/home/detroyejr/.nix-profile/bin
      [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh 
      [[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      source $HOME/.zsh/plugins/powerlevel10k/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $HOME/.p10k.zsh
      export EDITOR=nvim
      export ZK_NOTEBOOK_DIR=/mnt/c/Users/detro/OneDrive/Documents/zk-notes/
    '';
  };

  programs.tmux = {
    enable = true;    
    shortcut = "a";
    newSession = true;
    clock24 = true;
    extraConfig = 
      (builtins.readFile oh-my-tmux) +
      # Tmux and neovim colors. Things look slightly off at least in WSL2.
      "set-option -ga terminal-overrides \",xterm-256color:Tc\"";
  };
  


  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/ranger" = {
    source = ../dotfiles/ranger;
    recursive = true;
  };

  home.stateVersion = "22.11";
}
