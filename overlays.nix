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
}
