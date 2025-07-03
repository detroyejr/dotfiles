{
  pkgs,
  lib,
  config,
  isNvidia,
  ...
}:
{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ [ "--enable-sixaxis" ];
      });
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = lib.mkIf (!isNvidia) [
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
      ];
    };
    nvidia = lib.mkIf isNvidia {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  services = {
    libinput = {
      enable = true;
      touchpad = {
        accelSpeed = "0.5";
        naturalScrolling = false;
        scrollMethod = "twofinger";
        tappingDragLock = false;
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # Recommended with pipewire.
  security.rtkit.enable = true;

  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];

  services.xserver.displayManager.sessionCommands = ''
    eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
    export SSH_AUTH_SOCK
  '';

  security = {
    polkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock.text = lib.mkIf config.services.fprintd.enable ''
        # Account management.
        account required pam_unix.so

        # Authentication management.
        auth sufficient pam_unix.so   likeauth try_first_pass nullok
        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11400)
        auth required pam_deny.so

        # Password management.
        password sufficient pam_unix.so nullok sha512

        # Session management.
        session required pam_env.so conffile=/etc/pam/environment readenv=0
        session required pam_unix.so
      '';
    };
  };
}
