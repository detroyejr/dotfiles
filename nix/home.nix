{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.home-manager.enable = true;
  home.username = "detroyejr";
  home.homeDirectory = "/home/detroyejr";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    aircrack-ng
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
    mp4v2
    openssh
    unzip
    wget
    youtube-dl
    zk
    zsh-powerlevel10k
  ];
  
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      export PATH=$PATH:/home/detroyejr/.nix-profile/bin
      [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh 
      [[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      . $HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      . $HOME/.p10k.zsh
      export EDITOR=nvim
      export ZK_NOTEBOOK_DIR=/mnt/c/Users/detro/OneDrive/Documents/zk-notes/

      # Add a few aliases.
      alias k=kubectl
    '';
  };

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
  };

  # Theme for Powerlevel10k.
  home.file."/home/detroyejr/.p10k.zsh".source = ../zsh/.p10k.zsh;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
