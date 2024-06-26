{
  inputs,
  system,
  lib,
  isNvidia,
  isFprint,
  ...
}: {
  xdg.portal.config.common.default = "*";
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
