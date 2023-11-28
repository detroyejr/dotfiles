{ config, pkgs, lib, ... }:
{
  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow proprietary software (such as the NVIDIA drivers).
  nixpkgs.config.allowUnfree = true; 

  # Set time.
  services.ntp.enable = true;
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
}
