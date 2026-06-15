{
  lib,
  config,
  ...
}:
let
  cfg = config.services.prometheus;
  port = 9100;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.prometheus.retentionTime = "365d";

    services.prometheus.scrapeConfigs = [
      {
        job_name = "odp";
        scrape_interval = "20s";
        static_configs = [
          {
            targets = map (x: "odp-${x}:9100") [
              "1"
              "2"
              "3"
              "4"
              "5"
            ];
            labels = {
              alias = "odp";
            };
          }
        ];
      }
      {
        job_name = "pihole";
        scrape_interval = "20s";
        static_configs = [
          {
            targets = [ "pi.hole:9100" ];
            labels = {
              alias = "pi.hole";
            };
          }
        ];
      }
      {
        job_name = "scorpion";
        scrape_interval = "20s";
        static_configs = [
          {
            targets = [ "scorpion:9100" ];
            labels = {
              alias = "scorpion";
            };
          }
        ];
      }
    ];

    services.prometheus.exporters.node = {
      enable = true;
      port = port;
      enabledCollectors = [
        "cpu"
        "diskstats"
        "filesystem"
        "ethtool"
        "loadavg"
        "meminfo"
        "netdev"
        "stat"
        "time"
      ];
    };
  };
}
