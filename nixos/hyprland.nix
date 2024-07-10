{
  inputs,
  system,
  pkgs,
  lib,
  isNvidia,
  isFprint,
  ...
}: {
  xdg.portal.config.common.default = "*";

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

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "detroyejr";
      };
    };
    xserver = {
      displayManager.gdm.enable = true;
      enable = true;
      videoDrivers = lib.mkIf isNvidia ["nvidia"];
    };
  };
  security.pam.services.hyprlock.fprintAuth = isFprint;
}
