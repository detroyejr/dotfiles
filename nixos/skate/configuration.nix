{
  system,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ../jovian.nix
    ../cataclysm-dda.nix
    ../fonts.nix
    # ../hyprland.nix
    ../syncthing.nix
  ];

  fileSystems."/home/detroyejr/SD" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.authorizedKeysFiles = [
    "/home/detroyejr/.ssh/main_server_ed25519.pub"
  ];

  # programs = {
  #   dconf.enable = true;
  #   dconf.profiles."user".databases = [
  #       {
  #         settings = {
  #           "org/gnome/desktop/a11y/applications" = {
  #             screen-keyboard-enabled = true;
  #           };
  #         };
  #       }
  #     ];
  # };

  networking.hostName = "skate";
  services.xserver.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.11";
}
