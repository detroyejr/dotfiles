{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.wireshark;
in
{
  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      package = pkgs.wireshark;
      dumpcap.enable = true;
    };

    users.users.${config.defaultUser}.extraGroups = [
      "wireshark"
      "dumpcap"
    ];
  };
}
