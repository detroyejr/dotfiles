{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.quickshell;
in
{

  options = {
    programs.quickshell.enable = lib.mkEnableOption "custom whisper server module";
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = with pkgs; [
      omarchy-shell # Omarchy quickshell & scripts

      foot
      gum
      python3
      quickshell # For IPC 
      xdg-terminal-exec
      wireguard-tools
    ];
  };
}
