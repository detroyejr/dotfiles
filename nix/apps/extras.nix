{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    discord
    hyperion-ng
    joplin
    joplin-desktop
    keepassxc
    keeweb
    plex-media-player
    plexamp
    wireshark
  ];
}
