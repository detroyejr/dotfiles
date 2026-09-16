{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.opencode;
  defaultModel = "opencode/gpt-5.6-luna";
  stable = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/nixos-26.05";
    sha256 = "sha256:057izx0va3p74y74ga4381d5q1w700y9w9gw29m2y81zh9v9mri4";
  }) { system = "x86_64-linux"; };
in
{
  options.programs.opencode.enable = lib.mkEnableOption "Opencode CLI config";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      stable.opencode
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
