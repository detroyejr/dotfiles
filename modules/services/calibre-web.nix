{ config, lib, ... }:
let
  cfg = config.services.calibre-web;
in
{
  config = lib.mkIf cfg.enable {
    services.calibre-web = {
      listen.ip = "127.0.0.1";
      listen.port = 8083;
    };
  };
}
