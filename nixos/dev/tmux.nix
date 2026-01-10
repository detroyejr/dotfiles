{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    newSession = true;
    escapeTime = 10;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
    ];
    extraConfig = ''
      # Get 256 colors in Windows Terminal/WSL2.
      set -g default-terminal "screen-256color"
      set-option -ga terminal-overrides ',*-256color*:Tc'
      set -g mouse
      set-window-option -g mode-keys vi

      # We can use base index of 1 for everything but sessions.
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Keybindings
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      set-option -g status-style bg=default
    '';
  };
}
