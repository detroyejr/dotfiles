{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.veikkDriver ];
  # Will only be available to launch from programs like Rofi.
  environment.systemPackages = [ pkgs.veikk ];
}
