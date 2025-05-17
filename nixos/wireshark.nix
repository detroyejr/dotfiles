{ pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
  };

  users.users.detroyejr.extraGroups = [
    "wireshark"
    "dumpcap"
  ];
}
