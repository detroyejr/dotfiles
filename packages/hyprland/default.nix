let
  custom_splash = ./Splashes.hpp;
in
final: prev: {
  hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
    prePatch = ''
      cp  ${custom_splash} ./src/helpers/Splashes.hpp
    '';
  });
}
