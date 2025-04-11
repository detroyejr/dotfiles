{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "detroyejr";
  home.homeDirectory = "/home/detroyejr";
  programs.home-manager.enable = true;

  # NOTE: Disable during Source Hut outage.
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "$HOME/Downloads";
      documents = "$HOME/Documents";
      pictures = "$HOME/Documents/Pictures";
      videos = "$HOME/Documents/Videos";
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    awscli2
    bat
    bc
    curl
    fd
    ffmpeg
    file
    fzf
    gh
    jq
    just
    kubectl
    lsd
    lsof
    neofetch
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
    zsh-powerlevel10k
  ];

  programs.bash.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Theme for Powerlevel10k.
  home.file.".p10k.zsh".source = ../dotfiles/zsh/.p10k.zsh;

  home.sessionVariables = {
    "OLLAMA_HOST" = "mini-1.lan";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    shellAliases = {
      k = "kubectl";
      ll = "lsd -l";
      ls = "lsd";
      pwsh = "pwsh.exe";
      ssh = "TERM=xterm-256color ssh";
      st = "set-title";
      tf = "tmux-fzf";
      vim = "nvim";
      rm = "rm -I";
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
      plugins = [
        "git"
        "tmux"
      ];
      theme = "robbyrussell";
      package = pkgs.oh-my-zsh.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "ohmyzsh";
          repo = "ohmyzsh";
          rev = "695c7456d1a84697e9b86e11e839d5178cae743a";
          sha256 = "sha256-jFCqNVeX4LQhBQVicBhRNEIB+Ivo095cw/qyXFgbMoc=";
        };
      });
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

      if [ -d "$HOME/.local/bin/" ] ; then
          PATH="$HOME/.local/bin/:$PATH"
      fi

      if [ -d "$HOME/.local/bin/bash/" ] ; then
          PATH="$HOME/.local/bin/bash/:$PATH"
      fi

      [[ -f $HOME/.local/.secrets ]] && export $(cat ~/.local/.secrets)

      bindkey ^R history-incremental-search-backward
      bindkey ^S history-incremental-search-forward

      eval "$(direnv hook zsh)"

      # Yazi
      function ya() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };

  programs.tmux = {
    enable = true;
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
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # List of plugins.
      set -g @plugin 'jimeh/tmux-themepack'
      set -g @plugin 'sainnhe/tmux-fzf'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-yank'
      set -g @plugin 'tmux-plugins/tpm'
      set -g @themepack 'basic'

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

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      vim_keys = true;
    };
  };

  home.file.".digrc".text = ''
    +noall +answer
  '';

  home.file.".config/joplin/keymap.json".text = ''
      [
      { "keys": [":"], "type": "function", "command": "enter_command_line_mode" },
            { "keys": ["TAB", "l"], "type": "function", "command": "focus_next" },
            { "keys": ["SHIFT_TAB", "h"], "type": "function", "command": "focus_previous" },
            { "keys": ["UP", "k"], "type": "function", "command": "move_up" },
            { "keys": ["DOWN", "j"], "type": "function", "command": "move_down" },
            { "keys": ["PAGE_UP", "CTRL_U", "g"], "type": "function", "command": "page_up" },
            { "keys": ["PAGE_DOWN", "CTRL_D", "SHIFT_G"], "type": "function", "command": "page_down" },
            { "keys": ["ENTER"], "type": "function", "command": "activate" },
            { "keys": ["DELETE", "BACKSPACE"], "type": "function", "command": "delete" },
            { "keys": [" "], "command": "todo toggle $n" },
            { "keys": ["n"], "type": "function", "command": "next_link" },
            { "keys": ["b"], "type": "function", "command": "previous_link" },
            { "keys": ["o"], "type": "function", "command": "open_link" },
            { "keys": ["tc"], "type": "function", "command": "toggle_console" },
            { "keys": ["tm"], "type": "function", "command": "toggle_metadata" },
            { "keys": ["/"], "type": "prompt", "command": "search \"\"", "cursorPosition": -2 },
            { "keys": ["mn"], "type": "prompt", "command": "mknote \"\"", "cursorPosition": -2 },
            { "keys": ["mt"], "type": "prompt", "command": "mktodo \"\"", "cursorPosition": -2 },
            { "keys": ["mb"], "type": "prompt", "command": "mkbook \"\"", "cursorPosition": -2 },
            { "keys": ["yn"], "type": "prompt", "command": "cp $n \"\"", "cursorPosition": -2 },
            { "keys": ["dn"], "type": "prompt", "command": "mv $n \"\"", "cursorPosition": -2 }
    ]
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
          - "#linux"
          - "#neovim"
          - "#python"
          - "#nixos"
  '';

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.stateVersion = "23.11";
}
