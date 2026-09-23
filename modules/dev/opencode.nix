{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode/gpt-5.6-luna";
  opencode = inputs.opencode.outputs.packages.x86_64-linux.opencode.overrideAttrs (old: {
    postInstall = lib.optionalString (pkgs.stdenvNoCC.buildPlatform.canExecute pkgs.stdenvNoCC.hostPlatform) ''
      # trick yargs into also generating zsh completions
      installShellCompletion --cmd opencode \
        --bash <($out/bin/opencode --completions bash) \
        --zsh <(SHELL=/bin/zsh $out/bin/opencode --completions zsh)
    '';
  });
in
{
  options.programs.opencode.enable = lib.mkEnableOption "Opencode CLI config";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      opencode
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
      "xdg/opencode/agents".source = ../../dotfiles/opencode/agents;
      "xdg/opencode/skills".source = ../../dotfiles/opencode/skills;
    };
  };
}
