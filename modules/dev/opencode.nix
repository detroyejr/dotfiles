{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode/gpt-5.4";
in
{
  options.programs.opencode.enable = lib.mkEnableOption "Opencode CLI config";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.opencode
      pkgs.opencode-desktop
    ];

    environment.etc = {
      "xdg/opencode/opencode.jsonc".text = ''
        {
          "$schema": "https://opencode.ai/config.jsonc",
          "model": "${defaultModel}",
          "theme": "system",
          "lsp": {
            "ruff": {
              "command": ["ruff", "server"],
              "extensions": [".py"]
            },

            "jarl": {
              "command": ["jarl", "server"],
              "extensions": [".r", ".R"]
            }
          }
        }
      '';
      "xdg/opencode/agent".source = ../../dotfiles/opencode/agent;
    };
  };
}
