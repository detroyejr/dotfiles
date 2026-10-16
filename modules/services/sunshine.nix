{
  config,
  lib,
  ...
}:
let
  cfg = config.services.sunshine;
in
{
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        capture = "wlr";
        csrf_allowed_origins = "https://192.168.1.222:47990,https://sunshine.odp-1";
      };
    };
  };
}
