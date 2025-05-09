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

  programs.bash.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    "OLLAMA_HOST" = "mini-1.lan";
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
