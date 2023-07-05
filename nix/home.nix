{ pkgs, devenv, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.home-manager.enable = true;
  home.username = "detroyejr";
  home.homeDirectory = "/home/detroyejr";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    audible-cli
    awscli2
    bat
    bc
    cmake
    curl
    devenv.packages.x86_64-linux.devenv
    exa
    ffmpeg
    fzf
    gcc
    gh
    gnumake
    jq
    kubectl
    lame
    lua
    lua-language-server
    luaformatter
    mediainfo
    mitmproxy
    mp4v2
    neofetch
    nil
    nitch
    openssh
    ranger
    ripgrep
    tiny
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
    shellAliases = {
      ls = "exa";
      ll = "exa -l";
      st = "set-title";
      tf = "tmux-fzf";
      k = "kubectl";
      pwsh = "pwsh.exe";
      ranger = "ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd \"$LASTDIR\"";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "tmux" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      # ZSH Options
      DISABLE_AUTO_TITLE=true
      ZSH_TMUX_AUTOSTART=true
      ZSH_TMUX_AUTOCONNECT=true

      export PATH=$PATH:/home/detroyejr/.nix-profile/bin
      [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh 
      [[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      source $HOME/.zsh/plugins/powerlevel10k/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $HOME/.p10k.zsh
      

      export EDITOR=nvim
      export ZK_NOTEBOOK_DIR=/mnt/c/Users/detro/OneDrive/Documents/obsidian/zk-notes/
      
      if [ -d "$HOME/.local/bin/bash/" ] ; then
          PATH="$HOME/.local/bin/bash/:$PATH"
      fi

      [[ -f $HOME/.local/.secrets ]] && export $(cat ~/.local/.secrets)
      
      bindkey -v
      bindkey ^R history-incremental-search-backward 
      bindkey ^S history-incremental-search-forward
      '';
  };

  programs.tmux = {
    enable = true;    
    shortcut = "a";
    newSession = true;
    clock24 = true;
    extraConfig = ''
      # Get 256 colors in Windows Terminal/WSL2.
      set -g default-terminal "screen-256color"
      set-option -ga terminal-overrides ',*-256color*:Tc'
      set -g mouse
      set-window-option -g mode-keys vi
     
      # Fix weird character issue.
      set -g escape-time 10 
      
      # We can use base index of 1 for everything but sessions.
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Keybindings
      bind -n M-H previous-window
      bind -n M-L next-window
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # List of plugins.
      set -g @plugin "janoamaral/tokyo-night-tmux" 
      set -g @plugin 'christoomey/vim-tmux-navigator'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-yank'
      set -g @plugin 'tmux-plugins/tpm'

      # Set status color manually for tokyo night theme.
      # set -g status-bg "#1a1b26"
      set -g status-style bg=default

      run '$HOME/.tmux/plugins/tpm/tpm'
    '';
  };

  home.file.".tmux/plugins/tpm/".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "master";
    sha256 = "sha256-hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
  };
  

  home.file.".local/bin/bash".source = ../dotfiles/bash;

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/ranger" = {
    source = ../dotfiles/ranger;
    recursive = true;
  };

  home.file.".digrc".text = ''
  +noall +answer
  '';
  
  home.file.".config/tiny/config.yml".text = ''
    defaults:
      nicks: ["detroyejr"]
      realname: "Jon"
    servers:
      - addr: irc.libera.chat
        port: 6667
        realname: "Jon"
        nicks: ["detroyejr", "detroyejr510"]
        join:
          - "#neovim"
          - "#python"
  '';

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
  programs.direnv.nix-direnv.enableFlakes = true;

  home.stateVersion = "22.11";
}
