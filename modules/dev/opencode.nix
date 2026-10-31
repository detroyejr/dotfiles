{
  inputs,
  system,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode-go/gpt-6-luna";
  opencode = inputs.opencode.packages.${system}.default;
  opencode-desktop =
    (inputs.opencode.packages.${system}.opencode-desktop.override { inherit opencode; }).overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ./patches/opencode-pr-60683.patch ];
        postPatch = old.postPatch + ''
          substituteInPlace packages/desktop/script/build.ts \
            --replace-fail \
              'const cli = path.resolve(dir, "../cli/dist")' \
              'const cli = process.env.OPENCODE_CLI_DIST ?? path.resolve(dir, "../cli/dist")'
        '';
      });
in
{
  options.programs.opencode = {
    enable = lib.mkEnableOption "Opencode CLI config";
    package = lib.mkOption {
      type = lib.types.package;
      default = opencode;
      internal = true;
      readOnly = true;
      description = "The OpenCode CLI package used by OpenCode services.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
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
