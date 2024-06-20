{
  pkgs,
  lib,
  config,
  isNvidia,
  isFprint,
  ...
}: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ ["--enable-sixaxis"];
      });
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = lib.mkIf (!isNvidia) [
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
        pkgs.libvdpau-va-gl
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
      touchpad = lib.mkIf isFprint {
        scrollMethod = "twofinger";
        naturalScrolling = false;
      };
    };
    fprintd.enable = isFprint;
    gnome.gnome-keyring.enable = true;
    tlp.enable = true;
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

  security = {
    polkit.enable = true;
    pam.services.hyprlock.text = lib.mkIf isFprint ''
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
}
