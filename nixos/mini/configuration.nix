# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../default.nix
    ../../nix/fonts
    ../../nix/brightness
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.detroyejr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "input" "wireshark" "dialout" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      git
      docker
      virtiofsd
      pulseaudioFull
      alsa-utils
    ];
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam-small;
    };
    virt-manager.enable = true;
    zsh.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [xfce.exo];
    };
  };
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  environment.systemPackages = with pkgs; [
    gcc
    heroic
    parted
    mangohud
    rclone
    sbctl
    usbutils
    wget
    wl-clipboard
  ];

  systemd.services.onedrive = {
    path = ["${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH"];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p /home/detroyejr/OneDrive/
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 20G \
          --dir-cache-time 48h0m0s \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-onedrive.log \
          --umask 022 \
          --uid 1000 \
          --gid 1000 \
          --file-perms=0777 \
          --allow-other \
          --config=$FILE \
          "OneDrive:" "/home/detroyejr/OneDrive/"
      fi
    '';
    wantedBy = ["multi-user.target"];
  };

  systemd.services.google_drive = {
    path = ["${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH"];
    script = ''
      FILE=/root/.config/rclone/rclone.conf
      mkdir -p "/home/detroyejr/Google Drive"
      if test -f $FILE; then
        sleep 20
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-size 30G \
          --dir-cache-time 48h0m0s \
          --default-permissions \
          --log-level INFO \
          --log-file /tmp/rclone-google.log \
          --umask 022 \
          --file-perms=0777 \
          --uid 1000 \
          --gid 1000 \
          --allow-other \
          --config=$FILE \
          "Google Drive:" "/home/detroyejr/Google Drive/"
      fi
    '';
    wantedBy = ["multi-user.target"];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}