{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.immich-kiosk;
  kioskUrl = "https://kiosk.odp-1";
  kioskDesktopItem = pkgs.makeDesktopItem {
    name = "kiosk";
    desktopName = "Kiosk";
    comment = "Immich Kiosk";
    exec = "firefox-kiosk ${kioskUrl}";
    icon = "kiosk";
    terminal = false;
    type = "Application";
    startupNotify = true;
    startupWMClass = "firefox-kiosk";
  };
in
{
  config = lib.mkIf cfg.enable {
    services.immich-kiosk = {
      openFirewall = true;
      settings = {
        immich_url = "https://immich.odp-1";
        duration = 20;
        show_time = true;
        time_format = 12;
        show_am_pm = true;
        live_photos = true;
        live_photo_loop_delay = 60;
        filter_favorites = true;
        weather = {
          locations = [
            {
              name = "home";
              lat = "38.90";
              lon = "-77.27";
              unit = "imperial";
              lang = "en";
              forecast = false;
              default = true;
            }
          ];
        };
        kiosk = {
          port = 3000;
          behind_proxy = true;
        };
      };
    };
    systemd.services.immich-kiosk.serviceConfig.LoadCredential = [
      "kiosk_immich_api_key:${config.sops.secrets."immich-kiosk/api-key".path}"
      "kiosk_weather_api_key_file:${config.sops.secrets."immich-kiosk/weather-key".path}"
    ];
    environment.systemPackages = lib.mkIf config.programs.hyprland.enable [ kioskDesktopItem ];
    sops.secrets."immich-kiosk/api-key" = { };
    sops.secrets."immich-kiosk/weather-key" = { };
  };

}
