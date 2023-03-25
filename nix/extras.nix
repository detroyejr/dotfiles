{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    hyperion-ng
    keepass
    keeweb
    plex-media-player
    plexamp
    wireshark
  ];
}
