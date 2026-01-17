{ lib, config, ... }:
let
  port = 9100;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  services.prometheus.enable = lib.mkIf (config.system.name == "odp-2") true;

  services.prometheus.scrapeConfigs = [
    {
      job_name = "node";
      scrape_interval = "10s";
      static_configs = [
        {
          targets = [
            "odp-1:9100"
            "odp-2:9100"
            "odp-3:9100"
            "odp-4:9100"
            "odp-5:9100"
          ];
          labels = {
            alias = "odp";
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
}
