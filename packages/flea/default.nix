final: prev:
let
  version = "0.4.0";
  cargoTarget = prev.stdenv.hostPlatform.rust.rustcTarget;
  pythonRuntime = prev.python3.withPackages (packages: [ packages.pygobject3 ]);
  runtimeLibs = prev.lib.makeLibraryPath (
    with prev;
    [
      fontconfig
      gdk-pixbuf
      glib
      libglvnd
      libheif
      libxcb
      libxkbcommon
      mpv
      poppler
      vulkan-loader
      wayland
      final.localsend-cli
    ]
  );
in
{
  flea = prev.rustPlatform.buildRustPackage {
    pname = "flea";
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "thisisgm";
      repo = "flea";
      tag = "v${version}";
      hash = "sha256-zzGFgcpA2D3AwGKjt8H1cz9mwi/i/iqBNB4xLl35bZg=";
    };

    cargoHash = "sha256-eOl8EtxMEKpwRancasWjtYQ+su7WCpppiCtZ+rZ+WMU=";
    cargoBuildFlags = [
      "--workspace"
      "--bins"
    ];
    # Upstream's tests assert Arch paths and require an installed Omarchy desktop.
    doCheck = false;

    nativeBuildInputs = with prev; [
      makeWrapper
      pkg-config
    ];

    buildInputs = with prev; [
      fontconfig
      gdk-pixbuf
      glib
      libglvnd
      libheif
      libxkbcommon
      mpv
      poppler
      pythonRuntime
      wayland
      vulkan-loader
      libxcb
    ];

    postPatch = ''
      substituteInPlace src/backend/flashhelper.rs \
        --replace-fail '/usr/lib/flea/flea-udisks' '${placeholder "out"}/lib/flea/flea-udisks'
      substituteInPlace src/defaults.rs \
        --replace-fail '/usr/lib/flea/flea-filemanager1' '${placeholder "out"}/lib/flea/flea-filemanager1'
      substituteInPlace src/paths.rs src/gui/legacy_identity.rs \
        --replace-fail '/usr/share/flea/ui' '${placeholder "out"}/share/flea/ui'
      substituteInPlace src/i18n/mod.rs src/shelfplugin.rs \
        --replace-fail '/usr/share/flea' '${placeholder "out"}/share/flea'
      substituteInPlace crates/flea-gui/src/g2/pv3/mpris.rs \
        --replace-fail '/usr/lib/flea/flea-mpris' '${placeholder "out"}/lib/flea/flea-mpris'
      substituteInPlace crates/flea-gui/src/g2/pl2/mount_process.rs \
        --replace-fail '/usr/lib/flea/flea-gio-auth' '${placeholder "out"}/lib/flea/flea-gio-auth'
      substituteInPlace tools/flea-portal tools/flea-filemanager1 \
        --replace-fail '/usr/bin/flea' '${placeholder "out"}/bin/flea'
      substituteInPlace packaging/*.service \
        --replace-fail '/usr/lib/flea' '${placeholder "out"}/lib/flea'
      substituteInPlace packaging/com.thisisgm.flea.desktop \
        --replace-fail 'Exec=flea --gui' 'Exec=${placeholder "out"}/bin/flea --gui'
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/lib/flea" "$out/share"
      mkdir -p target/release
      ln -sf "../${cargoTarget}/release/flea" target/release/flea
      ln -sf "../${cargoTarget}/release/flea-gui" target/release/flea-gui
      make DESTDIR="$out" VERSION="${version}" install

      rm -f "$out/usr/share/flea/ui/Commons" "$out/usr/share/flea/ui/Ui" \
        "$out/usr/share/flea/ui/boot/Commons" "$out/usr/share/flea/ui/boot/Ui"

      mv "$out/usr/bin/"* "$out/bin/"
      mv "$out/usr/lib/flea/"* "$out/lib/flea/"
      rmdir "$out/usr/lib/flea"
      mv "$out/usr/share/flea" "$out/share/"
      mv "$out/usr/share/applications" "$out/share/"
      mv "$out/usr/share/dbus-1" "$out/share/"
      mv "$out/usr/share/icons" "$out/share/"
      mv "$out/usr/share/licenses" "$out/share/"
      mv "$out/usr/share/xdg-desktop-portal" "$out/share/"
      rm -rf "$out/usr"

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram "$out/bin/flea" \
        --prefix PATH : "$out/bin:${
          prev.lib.makeBinPath (
            with prev;
            [
              bat
              bubblewrap
              expect
              glib.bin
              jq
              pythonRuntime
              qt6.qtdeclarative
              qt6.qtwebengine
              ripgrep
              quickjs
              util-linux
              udisks2
              wl-clipboard
              xdg-utils
            ]
          )
        }" \
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --set FLEA_THEME_STOCK_DIR /etc/omarchy/themes \
        --set FLEA_GIO_AUTH "$out/lib/flea/flea-gio-auth" \
        --set FLEA_MPRIS "$out/lib/flea/flea-mpris"

      wrapProgram "$out/bin/flea-gui" \
        --prefix PATH : "$out/bin:${
          prev.lib.makeBinPath (
            with prev;
            [
              bubblewrap
              bat
              expect
              glib.bin
              jq
              pythonRuntime
              quickjs
              ripgrep
              util-linux
              udisks2
              wl-clipboard
              xdg-utils
            ]
          )
        }" \
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --set FLEA_THEME_STOCK_DIR /etc/omarchy/themes \
        --set FLEA_GIO_AUTH "$out/lib/flea/flea-gio-auth" \
        --set FLEA_MPRIS "$out/lib/flea/flea-mpris"
    '';

    meta = {
      description = "Fast, keyboard-first file manager";
      homepage = "https://github.com/thisisgm/flea";
      license = with final.lib.licenses; [
        mit
        asl20
        bsd2
        bsd3
        cc0
        isc
        mpl20
        final.lib.licenses."unicode-30"
        zlib
      ];
      mainProgram = "flea";
      platforms = final.lib.platforms.linux;
    };
  };
}
