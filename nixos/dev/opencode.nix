{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.opencode ];

  environment.etc = {
    "xdg/opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.jsonc",
        "theme": "system"
      }
    '';
    "xdg/opencode/agent".source = ../../dotfiles/opencode/agent;
  };
}
