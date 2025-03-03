# NOTE: Example patches.
# fprintd = prev.fprintd.overrideAttrs {
#   mesonCheckFlags = [
#     "--no-suite"
#     "fprintd:TestPamFprintd"
#   ];
# };

# nix = prev.nix.overrideAttrs {
#   # NOTE: Patch valid for nix v2.18.5
#   patches = [
#     (builtins.toFile "nice.patch" ''
#       diff --git a/src/libstore/build/local-derivation-goal.cc b/src/libstore/build/local-derivation-goal.cc
#       index 5ab231f24..de68d6768 100644
#       --- a/src/libstore/build/local-derivation-goal.cc
#       +++ b/src/libstore/build/local-derivation-goal.cc
#       @@ -1740,6 +1740,7 @@ void LocalDerivationGoal::runChild()
#                } catch (SysError &) { }
#
#        #if __linux__
#       +        nice(15);
#                if (useChroot) {
#
#                    userNamespaceSync.writeSide = -1;
#     '')
#   ];
# };

final: prev: {
  # Disable while coredump during test.
  calibre = prev.calibre.overrideAttrs {
    doInstallCheck = false;
  };
  xdg-desktop-portal = prev.xdg-desktop-portal.overrideAttrs {
    doCheck = false;
  };
  ark-posit =
    let
      pname = "ark";
      version = "0.1.159";
    in
    prev.rustPlatform.buildRustPackage {

      inherit pname version;
      src = prev.fetchFromGitHub {
        owner = "posit-dev";
        repo = pname;
        tag = version;
        hash = "sha256-dRF1PheW66ZVj+8MFzEk9RnewfWgJHIJVmfa0fpr1Ts=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-QkitKjfLW/aVeuff67SmLnxg7JAdMEaeW8YuEwQfrhw=";

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

  air-posit = import ./nixos/air/default.nix {
    fetchFromGitHub = prev.fetchFromGitHub;
    lib = prev.lib;
    rustPlatform = prev.rustPlatform;
  };

  positron-bin = prev.positron-bin.overrideAttrs (attrs: {
    src = prev.fetchurl {
      url = "https://github.com/posit-dev/positron/releases/download/2025.02.0-171/Positron-2025.02.0-171-x64.deb";
      hash = "sha256-TjQc/Y4Sa2MlLslbygYVFbIk3raArMvYstSiSEYzfo0=";
    };
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ prev.wrapGAppsHook ];
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share"
      cp -r usr/share/pixmaps "$out/share/pixmaps"
      cp -r usr/share/positron "$out/share/positron"

      mkdir -p "$out/share/applications"
      install -m 444 -D usr/share/applications/positron.desktop "$out/share/applications/positron.desktop"
      substituteInPlace "$out/share/applications/positron.desktop" \
        --replace-fail \
        "Icon=co.posit.positron" \
        "Icon=$out/share/pixmaps/co.posit.positron.png" \
        --replace-fail \
        "Exec=/usr/share/positron/positron %F" \
        "Exec=$out/share/positron/.positron-wrapped %F" \
        --replace-fail \
        "/usr/share/positron/positron --new-window %F" \
        "$out/share/positron/.positron-wrapped --new-window %F"

      # Fix libGL.so not found errors.
      wrapProgram "$out/share/positron/positron" \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.libglvnd ]}"

      mkdir -p "$out/bin"
      ln -s "$out/share/positron/positron" "$out/bin/positron"
      runHook postInstall
    '';
  });

  obs-studio-plugins = prev.obs-studio-plugins // {
    obs-hyperion = prev.obs-studio-plugins.obs-hyperion.overrideAttrs {
      patches = [
        (final.fetchpatch {
          url = "https://raw.githubusercontent.com/detroyejr/nixpkgs/897380107dfeedf4f352565c3f808067b16c7f06/pkgs/applications/video/obs-studio/plugins/obs-hyperion/check-state-changed.patch";
          hash = "sha256-HF7zWfPTAiBSNDYqBzEkaBFmk0xyqiIH01lE5CDWVWk=";
        })
      ];
    };
  };

  # air-posit =
  #   let
  #     pname = "air";
  #     version = "0.2.0";
  #     rev = "1c1125690200e44920fa0610f3283166022ba56f";
  #   in
  #   prev.stdenv.mkDerivation {
  #
  #     inherit pname version;
  #     src = prev.fetchFromGitHub {
  #       owner = "posit-dev";
  #       repo = pname;
  #       rev = rev;
  #       hash = "sha256-N2RV0CmwB9jK28mW3a+yQBDhLrTwukWqUhYP2oWGMpw=";
  #     };
  #
  #     useFetchCargoVendor = true;
  #     cargoLock = {
  #       lockFile = builtins.fetchurl {
  #         url = "https://raw.githubusercontent.com/posit-dev/air/${rev}/Cargo.lock";
  #         sha256 = "sha256:03qls2x1cgpdjylzrfsm7i96irq5sas907bxn2dvfy5vb87446x5";
  #       };
  #       outputHashes = {
  #         "biome_console-0.5.7" = "sha256-kEdA+o2ONthHQl7Nt6rVv6Kkt9LoqCeow/N5i5gkAVs=";
  #         "tower-lsp-0.20.0" = "sha256-XifEnsyyu7lATo5fdlmW5oM3RKCx7RtwryNUVGYIPLU=";
  #         "tree-sitter-r-1.1.0" = "sha256-ryKgJ+3dv/O2AN5zIGtQnKml0zU0/s4Io8Tumpm62Gc=";
  #       };
  #     };
  #
  #     doCheck = false;
  #
  #     buildInputs = [
  #       prev.libcxx
  #       prev.libgcc
  #     ];
  #
  #     nativeBuildInputs = [
  #       prev.autoPatchelfHook
  #       prev.rustPlatform.bindgenHook
  #     ];
  #   };
}
