{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.omarchy-quickshell;
  firefoxKiosk = pkgs.writeShellScriptBin "firefox-kiosk" ''
    profile="''${XDG_DATA_HOME:-$HOME/.local/share}/firefox-kiosk"
    mkdir -p "$profile"
    exec firefox \
      --no-remote \
      --profile "$profile" \
      --name firefox-kiosk \
      --class firefox-kiosk \
      --new-window \
      --kiosk "$@"
  '';
  omarchy = pkgs.omarchy-quickshell.overrideAttrs (attrs: {
    # The native screensaver package provides omarchy-launch-screensaver and
    # omarchy-screensaver, which would shadow the kiosk overrides below.
    runtimeInputs = builtins.filter (input: (input.pname or "") != "omarchy-screensaver") (
      attrs.runtimeInputs or [ ]
    );

    postPatch = (attrs.postPatch or "") + ''
      # Hyprpaper doesn't work with  webp so we'll convert.
      find themes -type f -iname "*.webp" -exec sh -c '${lib.getBin pkgs.imagemagick}/bin/magick "$1" "''${1%.*}.jpg"' _ {} \; \
        && find themes -type f -iname "*.webp" -delete

      substituteInPlace bin/omarchy-theme-bg-switcher \
        --replace-fail \
          'omarchy-menu-images \' \
          'omarchy-menu-images --lazy-thumbnails \'

      substituteInPlace shell/plugins/services/idle/Service.qml \
        --replace-fail \
          'readonly property string screensaverClass: "org.omarchy.screensaver"' \
          'readonly property string screensaverClass: "firefox-kiosk"'

      # The idle service launches through a login shell, and the upstream
      # wrapper puts the native omarchy-screensaver package ahead of this one
      # on PATH. Call the kiosk directly so the native binary can't win.
      # substituteInPlace shell/plugins/services/idle/Service.qml \
      #   --replace-fail \
      #     ']] || omarchy-launch-screensaver' \
      #     ']] || firefox-kiosk https://kiosk.odp-1'

      substituteInPlace shell/plugins/services/idle/Service.qml \
        --replace-fail \
          'readonly property int lockTimeoutSeconds: secondsFromConfig(idleConfig.lock, defaultLockSeconds)' \
          'readonly property int lockTimeoutSeconds: root.screensaverEnabled
        ? root.screensaverTimeoutSeconds + 3600
        : secondsFromConfig(idleConfig.lock, defaultLockSeconds)'

      cat > bin/omarchy-launch-screensaver <<'EOF'
      #!/usr/bin/env bash
      if omarchy-toggle-enabled screensaver-off && [[ "''${1:-}" != "force" ]]; then
        exit 1
      fi
      if [[ "''${1:-}" == "force" ]]; then
        shift
      fi
      exec firefox-kiosk https://kiosk.odp-1 "$@"
      EOF
      chmod +x bin/omarchy-launch-screensaver

      cat > bin/omarchy-screensaver <<'EOF'
      #!/usr/bin/env bash
      exec firefox-kiosk https://kiosk.odp-1 "$@"
      EOF
      chmod +x bin/omarchy-screensaver

      substituteInPlace bin/omarchy-system-lock \
        --replace-fail \
          "pkill -f '[o]rg.omarchy.screensaver' 2>/dev/null || true" \
          'pkill -f "[o]rg.omarchy.screensaver" 2>/dev/null || true
      hyprctl clients -j 2>/dev/null | jq -r --arg class "firefox-kiosk" ".[] | select(.class == \$class) | .address" | while IFS= read -r address; do
        [ -n "$address" ] && hyprctl dispatch closewindow "address:$address" >/dev/null 2>&1 || true
      done'
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

    users.users.${config.defaultUser}.packages =
      with pkgs;
      [
        foot
        chromium
        firefox
      ]
      ++ [ firefoxKiosk ];

    fonts.packages = lib.mkBefore [ omarchy ];
  };
}
