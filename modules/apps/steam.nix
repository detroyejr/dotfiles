{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.steam;
in
{
  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;

    # Extra game services.
    environment.systemPackages = with pkgs; [
      heroic
      mangohud
    ];
  };
}
