{ config, pkgs, lib, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    wireshark
    hyperion-ng
    aircrack-ng
    plexamp
    plex-media-player
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "plexamp"
  ];

}
