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
}
