{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nautilus;
in
{
  options.programs.nautilus.enable = lib.mkEnableOption "KDE Plasma desktop";
  config = lib.mkIf cfg.enable {
    users.users.${config.defaultUser}.packages = [
      pkgs.nautilus
    ];
  };
}
