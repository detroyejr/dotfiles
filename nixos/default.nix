{ pkgs, isNvidia, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
      randomizedDelaySec = "20min";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "http://mini-1.lan/?priority=10"
        "https://cache.nixos.org"
        "https://cosmic.cachix.org/" 
      ];
      trusted-public-keys = [ 
        "mini-1.lan:Qaw4+6mWCHqNCNL7Vnbo7KXFjjbyl64RaAMdCSEGzKI=" 
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];

      trusted-users = [
        "root"
        "detroyejr"
      ];
    };
  };
  programs.zsh.enable = true;
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

  hardware.nvidia.open = isNvidia;
}
