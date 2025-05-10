{ pkgs, isNvidia, ... }:
{
  imports = [
    ./dev
    ./tmux.nix
    ./zsh.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  nix = {
    distributedBuilds = true;
    extraOptions = ''
      # Ensure we can still build when missing-server is not accessible
      fallback = true
    '';
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
      randomizedDelaySec = "20min";
    };
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "http://mini-1.lan/?priority=10"
        "http://mini-2.lan/?priority=10"
        "http://mini-3.lan/?priority=10"
        "http://mini-4.lan/?priority=10"
        "http://mini-5.lan/?priority=10"
        "https://cache.nixos.org"
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [
        "mini-1.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "mini-2.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "mini-3.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "mini-4.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "mini-5.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];

      trusted-users = [
        "root"
        "detroyejr"
      ];
    };
    buildMachines =
      builtins.map
        (name: {
          hostName = name;
          sshUser = "detroyejr";
          sshKey = "/home/detroyejr/.ssh/mini_rsa";
          system = pkgs.stdenv.hostPlatform.system;
          maxJobs = 6;
          supportedFeatures = [
            "benchmark"
            "big-parallel"
            "kvm"
            "nixos-test"
          ];
        })
        [
          "mini-2"
          "mini-3"
          "mini-4"
          "mini-5"
        ];
  };

  programs.ssh.startAgent = true;
  services.ntp.enable = true;
  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    usbutils
    wget
    wl-clipboard
  ];

  users.users.detroyejr = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # TODO: is gamemode needed?
    extraGroups = [
      "wheel"
      "input"
      "dialout"
      "gamemode"
    ];
  };

  hardware.nvidia.open = pkgs.lib.mkDefault isNvidia;
}
