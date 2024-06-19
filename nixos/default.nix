{
  config,
  pkgs,
  lib,
  ...
}: {
  # Experimental
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set time.
  services.ntp.enable = true;
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
}
