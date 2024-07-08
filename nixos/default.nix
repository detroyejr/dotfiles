{pkgs, ...}: {
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.zsh.enable = true;
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
    extraGroups = ["wheel" "input" "dialout" "gamemode"];
  };
}
