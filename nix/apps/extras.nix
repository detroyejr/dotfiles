{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    discord
    hyperion-ng
    keepass
    keeweb
    plex-media-player
    plexamp
    wireshark
  ];
}
