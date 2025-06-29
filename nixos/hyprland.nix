{
  inputs,
  system,
  config,
  pkgs,
  lib,
  isNvidia,
  isFprint,
  ...
}:
{
  xdg.portal.config.common.default = "*";

  # FIXME: Some app don't respect my desktop theme.
  # Plex needs this to login/click on links.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.default.overrideAttrs (oldAttrs: {
      prePatch = ''
        cp ${../dotfiles/hyprland/Splashes.hpp} ./src/helpers/Splashes.hpp
      '';
    });
    xwayland = {
      enable = true;
    };
  };

  programs.dconf.enable = true;

  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "detroyejr";
      };
    };
    xserver = {
      enable = true;
      videoDrivers = lib.mkIf isNvidia [ "nvidia" ];
    };
  };
  security.pam.services.hyprlock.fprintAuth = isFprint;
}
