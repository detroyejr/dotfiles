{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.wezterm;
in
{
  options.programs.wezterm.enable = lib.mkEnableOption "WezTerm terminal";

  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = with pkgs; [ wezterm ];
  };
}
