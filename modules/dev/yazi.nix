{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.yazi;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = with pkgs; [ yazi ];
  };
}
