{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode-go/gpt-6-luna";
  opencode = inputs.opencode.outputs.packages.x86_64-linux.opencode;
  opencode-desktop = inputs.opencode.outputs.packages.x86_64-linux.opencode-desktop;
in
{
  options.programs.opencode.enable = lib.mkEnableOption "Opencode CLI config";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      opencode
      opencode-desktop
    ];

    environment.etc = {
      "xdg/opencode/opencode.jsonc".text = ''
        {
          "$schema": "https://opencode.ai/config.json",
          "model": "${defaultModel}",
          "theme": "system",
          "permissions": [
            { "action": "external_directory", "resource": "*", "effect": "ask" }
          ],
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
      "xdg/opencode/cli.json".text = ''
        {
          "$schema": "https://opencode.ai/v2/cli.json",
          "attention": {
            "notifications": true,
            "sound": true
          },
          "theme": {
            "name": "system",
            "mode": "system"
          }
        }
      '';
      "xdg/opencode/skills".source = ../../dotfiles/opencode/skills;
      "xdg/opencode/agents".source = ../../dotfiles/opencode/agents;
    };
  };
}
