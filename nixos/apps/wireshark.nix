{ pkgs, config, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
  };

  users.users.${config.defaultUser}.extraGroups = [
    "wireshark"
    "dumpcap"
  ];
}
