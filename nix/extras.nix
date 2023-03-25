{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    wireshark
    hyperion-ng
    aircrack-ng
    plex-media-player
    plexamp
  ];
}
