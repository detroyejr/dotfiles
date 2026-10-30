final: prev:
let
  version = "2.0.5";
in
{
  carrier = prev.rustPlatform.buildRustPackage {
    pname = "carrier";
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "kristofferR";
      repo = "Carrier";
      tag = "v${version}";
      hash = "sha256-noZYXUYX0HAmZwipVeZOXAapbZ2H0s4qnWG4wCwdEMc=";
    };

    sourceRoot = "source/src-tauri";
    cargoHash = "sha256-S5I/DWtuuK8bSdoa7hlffqIIKZJYv7fnN4tObaKLCoY=";

    # One upstream test asserts that release builds cannot use the updater.
    # Nixpkgs runs cargo tests in the release profile, so that debug-only test
    # fails even though Carrier's own CI tests the normal development profile.
    doCheck = false;

    nativeBuildInputs = [
      prev.appstream
      prev.copyDesktopItems
      prev.desktop-file-utils
      prev.pkg-config
      prev.wrapGAppsHook3
    ];

    buildInputs = [
      prev.glib
      prev.gst_all_1.gstreamer
      prev.gst_all_1.gst-plugins-base
      prev.gtk3
      prev.libayatana-appindicator
      prev.librsvg
      prev.libunwind
      prev.openssl
      prev.webkitgtk_4_1
    ];

    postInstall = ''
      install -Dm644 icons/32x32.png \
        "$out/share/icons/hicolor/32x32/apps/carrier.png"
      install -Dm644 icons/128x128.png \
        "$out/share/icons/hicolor/128x128/apps/carrier.png"
      install -Dm644 icons/128x128@2x.png \
        "$out/share/icons/hicolor/256x256/apps/carrier.png"
      install -Dm644 icons/icon.png \
        "$out/share/icons/hicolor/512x512/apps/carrier.png"
      install -Dm644 linux/io.github.kristofferr.carrier.metainfo.xml \
        "$out/share/metainfo/io.github.kristofferr.carrier.metainfo.xml"
    '';

    desktopItems = [
      (prev.makeDesktopItem {
        name = "Carrier";
        exec = "carrier";
        icon = "carrier";
        desktopName = "Carrier";
        comment = "A focused desktop client for Facebook Messenger";
        categories = [
          "Network"
          "InstantMessaging"
        ];
        startupWMClass = "carrier";
      })
    ];

    meta = {
      description = "A focused desktop client for Facebook Messenger";
      homepage = "https://github.com/kristofferR/Carrier";
      license = final.lib.licenses.mit;
      mainProgram = "carrier";
      platforms = final.lib.platforms.linux;
    };
  };
}
