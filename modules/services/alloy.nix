{ config, lib, ... }:
let
  cfg = config.services.alloy;
in
{
  config = lib.mkIf cfg.enable {
    environment.etc."alloy/config.alloy".text = lib.concatStringsSep "\n" [
      ''loki.write "odp" {''
      "\tendpoint {"
      "\t\turl = \"http://odp-1:3100/loki/api/v1/push\""
      "\t}"
      "}"
      ""
      ''loki.source.journal "system" {''
      "\tmax_age = \"12h\""
      "\tlabels  = {"
      "\t\tjob  = \"systemd-journal\","
      "\t\thost = \"${config.networking.hostName}\","
      "\t}"
      "\tforward_to = [loki.write.odp.receiver]"
      "}"
      ""
    ];
  };
}
