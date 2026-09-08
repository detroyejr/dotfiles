{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.archivebox;
  archiveboxSearchScript = pkgs.writeText "archivebox-search.py" ''
    from http.server import BaseHTTPRequestHandler, HTTPServer
    from subprocess import run
    from urllib.parse import parse_qs, urlparse
    from urllib.request import urlopen
    import json


    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            query = parse_qs(urlparse(self.path).query)
            term = query.get("q", [""])[0].strip()
            output, error = "", ""

            if term:
                result = run(
                    [
                        "docker",
                        "exec",
                        "archivebox",
                        "archivebox",
                        "search",
                        term,
                        "--json",
                    ],
                    capture_output=True,
                    text=True,
                )
                output = result.stdout.strip()
                error = result.stderr.strip()

            if output:
                status = 200
                body = output.replace(${builtins.toJSON "./archive/users/${cfg.adminUsername}/"}, "")
                body = json.loads(body)
                for b in body:
                  b["content"] = urlopen(
                    "http://127.0.0.1:8000/" + b.get("archive_url").replace("index.html", "readability/content.html")
                  ).read().decode()
                
            else:
                status = 500 if error else 200
                body = error

            self.send_response(status)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(json.dumps(body).encode())

    HTTPServer(("127.0.0.1", ${toString cfg.searchPort}), Handler).serve_forever()
  '';
in
{
  options.services.archivebox = {
    enable = lib.mkEnableOption "ArchiveBox docker service";

    image = lib.mkOption {
      type = lib.types.str;
      default = "archivebox/archivebox:dev";
      description = "ArchiveBox container image to run.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/archivebox";
      description = "Host directory used for ArchiveBox data.";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Public hostname used for ArchiveBox's base URL.";
    };

    adminUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "Initial ArchiveBox admin username.";
    };

    archiveboxPort = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Host-local port used by the ArchiveBox container.";
    };

    searchPort = lib.mkOption {
      type = lib.types.port;
      default = 8001;
      description = "Host-local port used by the ArchiveBox search proxy.";
    };

    httpsPort = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = "Host HTTPS port exposed by nginx.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    sops.secrets = {
      "archivebox/adminPassword" = { };
      "archivebox/sslCert" = {
        owner = "nginx";
        group = "nginx";
      };
      "archivebox/sslKey" = {
        owner = "nginx";
        group = "nginx";
      };
    };

    sops.templates."archivebox.env".content = ''
      ADMIN_PASSWORD=${config.sops.placeholder."archivebox/adminPassword"}
    '';

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root -"
      "d ${cfg.dataDir}/data 0750 root root -"
      "d ${cfg.dataDir}/data/personas 0750 root root -"
      "d ${cfg.dataDir}/tmp 0750 root root -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.archivebox = {
        image = cfg.image;
        pull = "always";
        ports = [ "127.0.0.1:${toString cfg.archiveboxPort}:8000" ];
        volumes = [
          "${cfg.dataDir}/data:/data"
          "${cfg.dataDir}/data/personas:/data/personas"
          "${cfg.dataDir}/tmp:/tmp/archivebox"
        ];
        environment = {
          ADMIN_USERNAME = cfg.adminUsername;
          BASE_URL = "https://${cfg.hostName}";
          PUBLIC_ADD_VIEW = "False";
        };
        environmentFiles = [ config.sops.templates."archivebox.env".path ];
        extraOptions = [
          "--pids-limit=2048"
          "--shm-size=1g"
        ];
      };
    };

    systemd.services.archivebox-search = {
      description = "ArchiveBox Search Server";
      after = [
        "network.target"
        "docker.service"
        "docker-archivebox.service"
      ];
      wants = [
        "docker.service"
        "docker-archivebox.service"
      ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        docker
        python3
      ];

      script = ''
        exec python3 ${archiveboxSearchScript}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.hostName} = {
        onlySSL = true;
        sslCertificate = config.sops.secrets."archivebox/sslCert".path;
        sslCertificateKey = config.sops.secrets."archivebox/sslKey".path;
        listen = [
          {
            addr = "0.0.0.0";
            port = cfg.httpsPort;
            ssl = true;
          }
        ];
        extraConfig = ''
          client_max_body_size 512m;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.archiveboxPort}";
        };
        locations."/search" = {
          proxyPass = "http://127.0.0.1:${toString cfg.searchPort}";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.httpsPort ];
  };
}
