{ ... }:
{
  # FIXME: cosmic works without setting XDG_CONFIG_HOME in envionment.etc
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;
}
