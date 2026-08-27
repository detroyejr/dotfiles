{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.omarchy-quickshell;
  omarchy = pkgs.omarchy-quickshell.overrideAttrs (attrs: {
    # Use /etc/xdg/CURRENT_THEME so that we can use nix defined themes.
    patchPhase = ''
      # substituteInPlace "shell/Commons/Color.qml" \
      #   --replace-fail \
      #   "path: root.home + \"/.config/omarchy/shell.toml\"" \
      #   "path: \"/etc/xdg/CURRENT_THEME/quickshell/shell.toml\""

      # Hyprpaper doesn't work with  webp so we'll convert.
      find themes -type f -iname "*.webp" -exec sh -c '${lib.getBin pkgs.imagemagick}/bin/magick "$1" "''${1%.*}.jpg"' _ {} \; \
        && find themes -type f -iname "*.webp" -delete

    '';
  });
in
{
  config = lib.mkIf cfg.enable {
    programs.omarchy-quickshell = {
      package = omarchy;
      background.enable = true;
      menu.enable = true;
      plugins = with pkgs.omarchyPlugins; [
        omarchy-bbs
        omarchy-wireguard
        omarchy-pihole
        omarchy-theme-manager
      ];
      settings.bar.layout.right = lib.mkBefore [
        { "id" = "io.github.thoughtlesslabs.omarchy-bbs"; }
        { "id" = "io.github.detroyejr.omarchy-pihole"; }
        { "id" = "remco.wireguard"; }
        { "id" = "io.github.mtolhuys.theme-manager"; }
      ];

    };

    users.users.${config.defaultUser}.packages = with pkgs; [
      foot
      chromium
    ];

    programs.chromium.enable = true;

    fonts.packages = lib.mkBefore [ omarchy ];
  };
}
