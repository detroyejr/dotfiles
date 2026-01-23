{ lib, config, ... }:
{

  sops.secrets = {
    "glance/piholePassword" = {
      owner = "detroyejr";
      group = "detroyejr";
    };
    "glance/location" = {
      owner = "detroyejr";
      group = "detroyejr";
    };
    "glance/freshrssUrl" = {
      owner = "detroyejr";
      group = "detroyejr";
    };
  };

  services.glance = {
    enable = true;
    openFirewall = lib.mkIf (config.system.name == "odp-1") true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 5678;
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                { type = "calendar"; }
                {
                  type = "twitch-channels";
                  channels = [
                    "chess"
                    "chess24"
                    "johnbartholomew"
                    "teej_dv"
                    "theprimeagen"
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "Work";
                      links = [
                        {
                          title = "Outlook";
                          url = "https://outlook.com";
                        }
                        {
                          title = "Github";
                          url = "https://github.com/";
                        }
                      ];
                    }
                    {
                      title = "Play";
                      color = "10 70 50";
                      links = [
                        {
                          title = "YouTube";
                          url = "https://www.youtube.com/";
                        }
                        {
                          title = "Chess.com";
                          url = "https://www.chess.com/";
                        }
                        {
                          title = "Chessable";
                          url = "https://www.chessable.com/";
                        }
                      ];
                    }
                    {
                      title = "Social";
                      color = "200 50 50";
                      links = [
                        {
                          title = "Reddit";
                          url = "https://www.reddit.com/";
                        }
                        {
                          title = "Twitter";
                          url = "https://twitter.com/";
                        }
                      ];
                    }
                    {
                      title = "Services";
                      color = "280 50 40";
                      links = [
                        {
                          title = "Plex";
                          url = "http://scorpion:32400/web";

                        }
                        {
                          title = "Pi-hole";
                          url = "http://pi.hole";

                        }
                        {
                          title = "Actual Budget";
                          url = "https://odp-1:3000";

                        }
                        {
                          title = "Grafana";
                          url = "http://odp-1:3001";

                        }
                        {
                          title = "FreshRSS";
                          url = "https://odp-1:8443";

                        }
                        {
                          title = "Prometheus";
                          url = "http://odp-2:9090";

                        }
                      ];
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "FreshRSS";
                  limit = 20;
                  style = "detailed-list";
                  collapse-after = 10;
                  cache = "20m";
                  feeds = [
                    {
                      url = {
                        _secret = config.sops.secrets."glance/freshrssUrl".path;
                      };
                      title = "FreshRSS";
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  units = "imperial";
                  location = {
                    _secret = config.sops.secrets."glance/location".path;
                  };
                }
                {
                  type = "custom-api";
                  title = "Daily Chess Puzzle";
                  cache = "6h";
                  url = "https://api.chess.com/pub/puzzle";
                  template = ''
                    <div style="text-align: center;">
                      <h3 style="font-size: 1.5rem; margin: 0 0 8px 0;">
                        <a href="{{ .JSON.String "url" }}" target="_blank" style="text-decoration: underline;">
                          {{ .JSON.String "title" }}
                        </a>
                      </h3>
                      <img src="{{ .JSON.String "image" }}" alt="Daily Chess Puzzle" style="max-width:100%; height:auto; border-radius: 3px;">
                    </div>
                  '';
                }
                {
                  type = "repository";
                  repository = "NixOS/nixpkgs";
                  pull-requests-limit = 5;
                  issues-limit = 5;
                  commits-limit = 3;
                }
              ];
            }
          ];
        }
        {
          name = "Services";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    {
                      title = "Plex";
                      url = "http://scorpion:32400/web";
                      alt-status-codes = [
                        200
                        403
                      ];
                    }
                    {
                      title = "Pi-hole";
                      url = "http://pi.hole";
                    }
                    {
                      title = "Actual Budget";
                      url = "https://odp-1:3000";
                      alt-status-codes = [
                        200
                        302
                      ];
                      allow-insecure = true;
                    }
                    {
                      title = "Grafana";
                      url = "http://odp-1:3001";
                    }
                  ];
                }

                {
                  type = "dns-stats";
                  service = "pihole-v6";
                  url = "https://pi.hole";
                  allow-insecure = true;
                  username = "detroyejr";
                  password = {
                    _secret = config.sops.secrets."glance/piholePassword".path;
                  };
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
