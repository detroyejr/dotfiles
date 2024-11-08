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
  # NOTE: obs needs to be overrided in a different way.
  obs-studio-plugins = prev.obs-studio-plugins // {
    obs-hyperion = prev.obs-studio-plugins.obs-hyperion.overrideAttrs {
      patches = [
        (final.fetchpatch {
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/c3ceedeac1ac9cbf8f0f99d96ff87b56e5dd3df8/pkgs/applications/video/obs-studio/plugins/obs-hyperion/check-state-changed.patch";
          hash = "sha256-cQTq8H9aUTpdUdaK94qIjTxqS9n4mVWlfZlxUoL4+JU=";
        })
      ];
    };
  };
  # Disable while coredump during test.
  calibre = prev.calibre.overrideAttrs {
    doInstallCheck = false;
  };

  R = prev.R.overrideAttrs (oldAttrs: {
    postFixup = ''
      echo ${prev.which} > $out/nix-support/undetected-runtime-dependencies
      find $out -name "*.so" -exec patchelf {} --add-rpath $out/lib/R/lib \;
    '';
  });

  ark-posit =
    let
      pname = "ark";
      version = "0.5.1";
      rev = "b8505c504eb10be0e9cb948e1631f151825facdb";
    in
    prev.rustPlatform.buildRustPackage {

      inherit pname version;
      src = prev.fetchFromGitHub {
        owner = "posit-dev";
        repo = pname;
        rev = rev;
        hash = "sha256-+0+UFiJsQKFT/DLeu3LF8RFik7Iqv873gzu+RP83GiA=";
      };

      cargoLock = {
        lockFile = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/posit-dev/ark/${rev}/Cargo.lock";
          sha256 = "sha256:1v5klikaib1cf6d9qggqa3cch4jscl5ixibi1bbfa9bhcky86fjh";
        };
        outputHashes = {
          "dap-0.4.1-alpha1" = "sha256-nUsTazH1riI0nglWroDKDWoHEEtNEtpwn6jCH2N7Ass=";
          "tree-sitter-r-1.1.0" = "sha256-a7vgmOY9K8w8vwMlOLBmUnXpWpVP+YlOilGODaI07y4=";
        };
      };

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
}
