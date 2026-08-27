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
      omarchy-quickshell # Omarchy quickshell & scripts

      foot
      gum
      quickshell # For IPC 
      xdg-terminal-exec
    ];
  };
}
