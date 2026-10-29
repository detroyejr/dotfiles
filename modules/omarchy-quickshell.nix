{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.omarchy-quickshell;
  omarchy = pkgs.omarchy-quickshell.overrideAttrs (attrs: {
    postPatch = (attrs.postPatch or "") + ''
      # Hyprpaper doesn't work with  webp so we'll convert.
      find themes -type f -iname "*.webp" -exec sh -c '${lib.getBin pkgs.imagemagick}/bin/magick "$1" "''${1%.*}.jpg"' _ {} \; \
        && find themes -type f -iname "*.webp" -delete

    '';

    postInstall = (attrs.postInstall or "") + ''
      install -d "$out/share/omarchy/shell/plugins/splash"
      cp -r ${../dotfiles/omarchy/plugins/splash}/. "$out/share/omarchy/shell/plugins/splash"
    '';
  });
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets."glance/piholePassword" = {
      owner = "detroyejr";
    };
    programs.omarchy-quickshell = {
      package = omarchy;
      background.enable = true;
      menu.enable = true;
      settings.disabledPlugins = [ "omarchy.notifications" ];
      launcher.hiddenEntries = [
        "Basecamp"
        "Discord"
        "Google Contacts"
        "Google Maps"
        "Google Messages"
        "Google Photos"
        "HEY"
        "WhatsApp"
        "Zoom"
      ];
    };

    users.users.${config.defaultUser}.packages = with pkgs; [
      foot
      chromium
    ];

    fonts.packages = lib.mkBefore [ omarchy ];
  };
}
