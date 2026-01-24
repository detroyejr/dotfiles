{
  pkgs,
  config,
  isNvidia,
  ...
}:
{
  programs.zsh.enable = true;

  imports = [
    ../modules
    ./apps/yazi.nix
    ./dev
    ./dev/tmux.nix
    ./dev/wezterm.nix
    ./dev/zsh.nix
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
        "http://odp-1/?priority=10"
        "http://odp-2/?priority=10"
        "http://odp-3/?priority=10"
        "http://odp-4/?priority=10"
        "http://odp-5/?priority=10"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "odp-1:ep03YNVn5yTQNfdD9ATHGvgfG1kiwACJxyCOXoI96bU="
      ];

      trusted-users = [
        "root"
        "detroyejr"
      ];
    };
    buildMachines =
      map
        (name: {
          hostName = name;
          sshUser = "detroyejr";
          sshKey = "/home/detroyejr/.ssh/mini_rsa";
          system = pkgs.stdenv.hostPlatform.system;
          maxJobs = 6;
          supportedFeatures = [
            "benchmark"
            "kvm"
            "nixos-test"
          ];
        })
        [
          "odp-2"
          "odp-3"
          "odp-4"
          "odp-5"
        ];
  };

  services = {
    ntp.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
  };

  security.pki.certificateFiles = [ ../dotfiles/ca/ca.crt ];

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    usbutils
    wget
    wl-clipboard
    gcr
  ];

  users.users.${config.defaultUser} = {
    isNormalUser = true;
    group = config.defaultUser;
    shell = pkgs.zsh;
    # TODO: is gamemode needed?
    extraGroups = [
      "wheel"
      "input"
      "dialout"
      "gamemode"
    ];
  };
  users.groups.detroyejr = { };

  hardware.nvidia.open = pkgs.lib.mkDefault isNvidia;
}
