final: prev: {
  localsend-cli = prev.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "localsend-cli";
    version = "1.18.2";

    src = prev.fetchFromGitHub {
      owner = "localsend";
      repo = "localsend";
      tag = "v${finalAttrs.version}";
      hash = "sha256-hP4whBkBQ/FEnUOjgeC+HIzrWhtbME6HGxmwwvTSSeI=";
    };

    cargoHash = "sha256-lgg+f7gLHUG4pYUAJW+nIrS8vUX4x+daupgCG8jct/Q=";

    cargoBuildFlags = [
      "--package"
      "localsend-cli"
    ];

    checkInputs = [ prev.cacert ];
    __darwinAllowLocalNetworking = true;

    meta = {
      description = "Open source cross-platform alternative to AirDrop (CLI version)";
      homepage = "https://github.com/localsend/localsend";
      license = final.lib.licenses.asl20;
      mainProgram = "localsend-cli";
    };
  });

  localsendDesktop =
    let
      src = prev.fetchFromGitHub {
        owner = "localsend";
        repo = "localsend";
        rev = "af0416be50770a97760f7070684bc667b759a15c";
        hash = "sha256-hP4whBkBQ/FEnUOjgeC+HIzrWhtbME6HGxmwwvTSSeI=";
      };
      lock = final.lib.importJSON (
        prev.runCommand "localsend-pubspec-lock.json"
          {
            nativeBuildInputs = [ prev.yq ];
          }
          ''
            yq . ${src}/pubspec.lock > "$out"
          ''
      );
      pubspecLock = lock // {
        packages = lock.packages // {
          localsend_isolates = {
            dependency = "direct main";
            description = {
              path = "packages/localsend_isolates";
              relative = true;
            };
            source = "path";
            version = "0.0.1";
          };
          typed_isolates = {
            dependency = "transitive";
            description = {
              path = "packages/typed_isolates";
              relative = true;
            };
            source = "path";
            version = "1.0.0";
          };
        };
      };
    in
    prev.flutter341.buildFlutterApplication (finalAttrs: {
      pname = "localsend";
      version = "1.18.2";
      inherit src;
      strictDeps = true;

      sourceRoot = "${finalAttrs.src.name}/app";
      packageRoot = ".";
      inherit pubspecLock;

      gitHashes = {
        device_apps = "sha256-oreTBOYh4J2N4HhY2gxNwwxfl1OSAZRH1GOeVrH8LG8=";
        pasteboard = "sha256-lJA5OWoAHfxORqWMglKzhsL1IFr9YcdAQP/NVOLYB4o=";
        permission_handler_windows = "sha256-+TP3neqlQRZnW6BxHaXr2EbmdITIx1Yo7AEn5iwAhwM=";
      };

      postPatch = ''
        substituteInPlace lib/util/native/autostart_helper.dart \
          --replace-fail 'Exec=''${Platform.resolvedExecutable}' "Exec=localsend_app"
      '';

      nativeBuildInputs = [ prev.copyDesktopItems ];
      buildInputs = [ prev.libayatana-appindicator ];

      customSourceBuilders.rust_lib_localsend_app =
        { version, src, ... }:
        prev.stdenvNoCC.mkDerivation (finalAttrs': {
          pname = "rust_lib_localsend_app";
          inherit version src;
          passthru = (src.passthru or { }) // {
            packageRoot = "packages/localsend_isolates/rust_builder";
          };

          postPatch = ''
            pushd packages/localsend_isolates/rust_builder
            patch -p1 <${
              prev.replaceVars (prev.path + "/pkgs/by-name/lo/localsend/no-cargokit.patch") {
                inherit (finalAttrs.passthru) rustLib;
              }
            }
            popd
          '';

          installPhase = ''
            runHook preInstall
            cp -r . $out
            runHook postInstall
          '';
        });

      postInstall = ''
        for s in 32 128 256 512; do
          d=$out/share/icons/hicolor/''${s}x''${s}/apps
          mkdir -p $d
          cp assets/img/logo-''${s}.png $d/localsend.png
        done
      '';

      extraWrapProgramArgs = ''
        --prefix LD_LIBRARY_PATH : $out/app/localsend/lib
      '';

      desktopItems = [
        (prev.makeDesktopItem {
          name = "LocalSend";
          exec = "localsend_app %U";
          icon = "localsend";
          desktopName = "LocalSend";
          startupWMClass = "org.localsend.localsend_app";
          comment = finalAttrs.meta.description;
          genericName = "File Transfer";
          categories = [
            "GTK"
            "FileTransfer"
            "Network"
            "Utility"
          ];
          keywords = [
            "Sharing"
            "LAN"
            "Files"
          ];
          startupNotify = true;
        })
      ];

      passthru = {
        rustLib = prev.rustPlatform.buildRustPackage {
          pname = "localsend-rust-lib";
          inherit (finalAttrs) version src;
          cargoHash = "sha256-lgg+f7gLHUG4pYUAJW+nIrS8vUX4x+daupgCG8jct/Q=";
          buildAndTestSubdir = "packages/localsend_isolates/rust";
        };
        tests = { inherit (prev.nixosTests) localsend; };
      };

      meta = prev.localsend.meta // {
        mainProgram = "localsend_app";
        platforms = final.lib.platforms.linux;
      };
    });
}
