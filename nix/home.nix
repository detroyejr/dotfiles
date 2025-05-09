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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.stateVersion = "23.11";
}
