{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.hyprland.enable {
    users.users.${config.defaultUser}.packages = with pkgs; [ wezterm ];
  };
}
