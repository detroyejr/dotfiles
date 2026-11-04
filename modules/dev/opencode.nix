{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode-go/gpt-6-luna";
in
{
  options.programs.opencode = {
    enable = lib.mkEnableOption "Opencode CLI config";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.opencode;
      internal = true;
      readOnly = true;
      description = "The OpenCode CLI package used by OpenCode services.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.opencode-desktop
    ];

    environment.etc = {
      "xdg/opencode/opencode.jsonc".text = ''
        {
          "$schema": "https://opencode.ai/config.json",
          "model": "${defaultModel}",
          "theme": "system",
          "plugins": ["opencode-mobile-notifications"],
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
          },
          "mcp": {
            "servers": {
              "browse": {
                "type": "local",
                "command": [
                  "${pkgs.nodejs-slim}/bin/node",
                  "/home/detroyejr/Documents/browse/cli/dist/cli.mjs",
                  "mcp"
                ],
                "environment": {
                  "OPENCODE_BROWSER_RUNTIME": "3dbca73289567ad0"
                }
              }
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
