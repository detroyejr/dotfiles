# Overlays
# Add custom packages or patches when things break.

final: prev: {
  whisper-cpp = prev.whisper-cpp.overrideAttrs (attrs: { 
    src = prev.fetchFromGitHub {
      owner = "ggml-org";
      repo = "whisper.cpp";
      rev = "b175baa665bc35f97a2ca774174f07dfffb84e19";
      hash = "sha256-GtGzUNpIbS81z7SXFolT866fGfdSjdyf9R+PKlK6oYs=";
    };
  });
  custom-whisper-server = prev.stdenv.mkDerivation {
    name = "custom-whisper-server";
    version = "0.1";
    src = prev.fetchFromGitHub {
      owner = "detroyejr";
      repo = "custom-whisper-server";
      rev = "d23c4fc31c71904ee3c7202dc554ea0eb46d6ede";
      hash = "sha256-HBzUVPo+A+8RR/D1Tj+fXN+Y88tgXuQmcWd7/RiDM24=";
    };
    buildInputs = with final; [
      cmake
      httplib
      nlohmann_json
      whisper-cpp
    ];
    nativeBuildInputs = [prev.yt-dlp];
      
    installPhase = ''
      mkdir -p $out $out/bin
      cp custom-whisper-server $out/bin
      cp ${final.whisper-cpp}/bin/*.so $out/bin
    '';
  };
  ark-posit =
    let
      pname = "ark";
      version = "0.1.182";
    in
    prev.rustPlatform.buildRustPackage {

      inherit pname version;
      src = prev.fetchFromGitHub {
        owner = "posit-dev";
        repo = pname;
        tag = version;
        hash = "sha256-ajGquqGKs002mJihnHoaMW+qkc4zgqGRnMT4b2BT2cU=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-xPIPEugJKS7nGcc+kKRCmNptTgcd6yK8sqBFO/Hpj0U=";

      doCheck = false;

      buildInputs = [
        prev.libcxx
        prev.libgcc
      ];

      nativeBuildInputs = [
        prev.autoPatchelfHook
        prev.rustPlatform.bindgenHook
      ];
    };

  plasmadeck-vapor-theme =
    let
      pname = "plasmadeck-vapor-theme";
      version = "0.11";

      plasmadeck = prev.stdenv.mkDerivation {
        pname = "plasmadeck-kde-theme";
        version = "20220902";

        src = prev.fetchFromGitHub {
          owner = "varlesh";
          repo = "plasma-deck";
          rev = "b03f24240b4d7450524e1731aa19b8884df9c864";
          sha256 = "sha256-GZanIQdGiLp2Luosr+LwED1xirgMVCHbU3bTRsNMLiU=";
        };

        patches = [
          (prev.writeText "colors.patch" ''
            diff --git a/color-schemes/PlasmaDeck.colors b/color-schemes/PlasmaDeck.colors
            index 55dbc44..1f8a5b2 100644
            --- a/color-schemes/PlasmaDeck.colors
            +++ b/color-schemes/PlasmaDeck.colors
            @@ -80,8 +80,8 @@ ForegroundPositive=61,139,63
             ForegroundVisited=173,101,175
             
             [Colors:View]
            -BackgroundAlternate=35,38,46
            -BackgroundNormal=35,38,46
            +BackgroundAlternate=14,19,26
            +BackgroundNormal=14,19,26
             DecorationFocus=26,159,255
             DecorationHover=26,159,255
             ForegroundActive=254,254,254
            @@ -94,8 +94,8 @@ ForegroundPositive=61,139,63
             ForegroundVisited=173,101,175
             
             [Colors:Window]
            -BackgroundAlternate=14,19,26
            -BackgroundNormal=14,19,26
            +BackgroundAlternate=35,38,46
            +BackgroundNormal=35,38,46
             DecorationFocus=26,159,255
             DecorationHover=26,159,255
             ForegroundActive=254,254,254
          '')
        ];

        # NOTE: We don't install any wallpapers
        installPhase = ''
          runHook preInstall

          mkdir -p $out/share
          mv color-schemes $out/share/color-schemes
          mv plasma $out/share/plasma
          mv aurorae $out/share/aurorae

          runHook postInstall
        '';
      };
    in
    prev.stdenv.mkDerivation {
      inherit pname version;

      # TODO: Replace with https://gitlab.steamos.cloud/jupiter/steamdeck-kde-presets once it becomes public
      src = prev.fetchFromGitHub {
        name = "steamdeck-kde-presets-${version}";
        owner = "Jovian-Experiments";
        repo = "steamdeck-kde-presets";
        rev = version;
        sha256 = "sha256-rolekomsjHoqgDE5n1tx6g6uIOgbFK9zFoapmVLuA2w=";
      };

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share
        cp -r usr/share/{color-schemes,konsole,plasma,themes,wallpapers} $out/share

        # other icons (install-firefox, distributor-logo) are not applicable to NixOS
        mkdir -p $out/share/icons/hicolor/scalable/actions
        cp usr/share/icons/hicolor/scalable/actions/* $out/share/icons/hicolor/scalable/actions

        runHook postInstall
      '';

      postInstall = ''
        # merge PlasmaDeck icons
        mkdir -p $out/share/plasma/desktoptheme/Vapor/icons
        cp ${plasmadeck.out}/share/plasma/desktoptheme/PlasmaDeck/icons/* $out/share/plasma/desktoptheme/Vapor/icons
      '';

      meta = with prev.lib; {
        description = "Steam Deck Vapor theme with gamescope icons for KDE";
        license = licenses.gpl2;
      };
    };

  plex-htpc =
    let
      pname = "plex-htpc";
      version = "1.70.1";
      rev = "71";
      meta = {
        homepage = "https://plex.tv/";
        description = "Plex HTPC client for the big screen";
        longDescription = ''
          Plex HTPC for Linux is your client for playing on your Linux computer
          connected to the big screen. It features a 10-foot interface with a
          powerful playback engine.
        '';
        maintainers = with prev.lib.maintainers; [ detroyejr ];
        license = prev.lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        mainProgram = "plex-desktop";
      };
      plex-htpc = prev.stdenv.mkDerivation {
        inherit pname version meta;

        src = prev.fetchurl {
          url = "https://api.snapcraft.io/api/v1/snaps/download/81OP06hEXlwmMrpMAhe5hyLy5bQ9q6Kz_${rev}.snap";
          hash = "sha256-KztTiq71v4GA0MEbNba8oaXd24h0Sr2wiINZ/B9FcFI=";
        };

        nativeBuildInputs = with prev; [
          autoPatchelfHook
          makeShellWrapper
          squashfsTools
        ];

        buildInputs = with prev; [
          elfutils
          ffmpeg_6-headless
          libpulseaudio
          libva
          libxkbcommon
          minizip
          nss
          stdenv.cc.cc
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXinerama
          xorg.libXrandr
          xorg.libXrender
          xorg.libXtst
          xorg.libxshmfence
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.xcbutilwm
          xorg.xrandr
        ];

        strictDeps = true;

        unpackPhase = ''
          runHook preUnpack
          unsquashfs "$src"
          cd squashfs-root
          runHook postUnpack
        '';

        dontWrapQtApps = true;

        installPhase = ''
          runHook preInstall

          cp -r . $out
          rm -r $out/etc
          rm -r $out/usr

          # flatpak removes these during installation.
          rm -r $out/lib/dri
          rm $out/lib/libpciaccess.so*
          rm $out/lib/libswresample.so*
          rm $out/lib/libva-*.so*
          rm $out/lib/libva.so*
          rm $out/lib/libEGL.so*
          rm $out/lib/libdrm.so*
          rm $out/lib/libdrm*

          # Keep some dependencies from the snap.
          cp usr/lib/x86_64-linux-gnu/liblcms2.so.2 $out/lib/liblcms2.so.2
          cp usr/lib/x86_64-linux-gnu/libjbig.so.0 $out/lib/libjbig.so.0
          cp usr/lib/x86_64-linux-gnu/libjpeg.so.8 $out/lib/libjpeg.so.8
          cp usr/lib/x86_64-linux-gnu/libpci.so.3 $out/lib/libpci.so.3
          cp usr/lib/x86_64-linux-gnu/libsnappy.so.1 $out/lib/libsnappy.so.1
          cp usr/lib/x86_64-linux-gnu/libtiff.so.5 $out/lib/libtiff.so.5
          cp usr/lib/x86_64-linux-gnu/libwebp.so.6 $out/lib/libwebp.so.6
          cp usr/lib/x86_64-linux-gnu/libxkbfile.so.1 $out/lib/libxkbfile.so.1
          cp usr/lib/x86_64-linux-gnu/libxslt.so.1 $out/lib/libxslt.so.1
          cp usr/lib/x86_64-linux-gnu/libxml2.so.2 $out/lib/libxml2.so.2

          runHook postInstall
        '';
      };
    in
    prev.buildFHSEnv {
      inherit pname version meta;
      targetPkgs =
        pkgs: with prev; [
          alsa-lib
          libdrm
          xkeyboard_config
        ];

      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/scalable/apps
        install -m 444 -D ${plex-htpc}/meta/gui/plex-htpc.desktop $out/share/applications/plex-htpc.desktop
        substituteInPlace $out/share/applications/plex-htpc.desktop \
          --replace-fail \
          'Icon=''${SNAP}/meta/gui/icon.png' \
          'Icon=${plex-htpc}/meta/gui/icon.png'
      '';

      runScript = prev.writeShellScript "plex-htpc.sh" ''
        # Widevine won't download unless this directory exists.
        mkdir -p $HOME/.cache/plex/

        # Copy the sqlite plugin database on first run.
        PLEX_DB="$HOME/.local/share/Plex HTPC/Plex Media Server/Plug-in Support/Databases"
        if [[ ! -d "$PLEX_DB" ]]; then
          mkdir -p "$PLEX_DB"
          cp "${plex-htpc}/resources/com.plexapp.plugins.library.db" "$PLEX_DB"
        fi

        # db files should have write access.
        chmod --recursive 750 "$PLEX_DB"

        set -o allexport
        exec ${plex-htpc}/Plex.sh
      '';
      passthru.updateScript = ./update.sh;
    };
}
