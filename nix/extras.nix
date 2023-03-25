{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    hyperion-ng
    keepass
    plex-media-player
    plexamp
    wireshark
  ];
}
