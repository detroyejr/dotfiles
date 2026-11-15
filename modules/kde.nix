{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.kde;
in
{
  options.programs.kde.enable = lib.mkEnableOption "KDE Plasma desktop";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
      xserver.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      windows95-kde-theme
    ];
  };
}
