{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.opencode ];

  environment.etc = {
    "xdg/opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.jsonc",
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
}
