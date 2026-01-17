{ lib, config, ... }:
let
  port = 9100;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  services.prometheus = {
    enable = lib.mkIf (config.system.name == "odp-2") true;
    retentionTime = "12m";
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "odp-1";
      scrape_interval = "20s";
      static_configs = [
        {
          targets = [ "odp-1:9100" ];
          labels = {
            alias = "odp-1";
          };
        }
      ];
    }
    {
      job_name = "odp-2";
      scrape_interval = "20s";
      static_configs = [
        {
          targets = [ "odp-2:9100" ];
          labels = {
            alias = "odp-2";
          };
        }
      ];
    }
    {
      job_name = "odp-3";
      scrape_interval = "20s";
      static_configs = [
        {
          targets = [ "odp-3:9100" ];
          labels = {
            alias = "odp-3";
          };
        }
      ];
    }
    {
      job_name = "odp-4";
      scrape_interval = "20s";
      static_configs = [
        {
          targets = [ "odp-4:9100" ];
          labels = {
            alias = "odp-4";
          };
        }
      ];
    }
    {
      job_name = "odp-5";
      scrape_interval = "20s";
      static_configs = [
        {
          targets = [ "odp-5:9100" ];
          labels = {
            alias = "odp-5";
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
