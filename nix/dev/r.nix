{ pkgs, ... }:
with pkgs;
let
  R-with-packages = rWrapper.override {
    packages =
      with rPackages;
      let
        surveytools = buildRPackage {
          name = "EchelonSurveyTools";
          src = builtins.fetchGit {
            url = "git@github.com:echeloninsights/EchelonSurveyTools.git";
            rev = "eb2550194ff022b31d6a100fb71d7d7c3908da88";
            allRefs = true;
          };
          buildInputs = [
            RMariaDB
            RPostgres
            haven
            httr
            pkgs.R
            relaimpo
            scales
            sjlabelled
            stringi
            tibble
          ];
        };
        topline = buildRPackage {
          name = "Topline";
          src = builtins.fetchGit {
            url = "git@github.com:echeloninsights/topline.git";
            rev = "a02ea59d3178dc32da226b750072954cd4cb0134";
          };
          buildInputs = with rPackages; [
            flextable
            ftExtra
            googledrive
            haven
            huxtable
            knitr
            officer
            pkgs.R
            rmarkdown
            sjlabelled
            stringi
          ];
        };
      in
      [
        RMariaDB
        RPostgres
        data_table
        dplyr
        flextable
        ftExtra
        googledrive
        haven
        httr
        huxtable
        magick
        officer
        # quarto
        readxl
        relaimpo
        sf
        sjlabelled
        stringi
        surveytools
        topline
        usethis
      ];
  };
in
{
  home.packages = [
    R-with-packages
    ark-posit
    air-posit
    pandoc
    (positron-bin.overrideAttrs(attrs: {
      src =  fetchurl {

        url = "https://github.com/posit-dev/positron/releases/download/2025.02.0-171/Positron-2025.02.0-171-x64.deb";
        hash = "sha256-TjQc/Y4Sa2MlLslbygYVFbIk3raArMvYstSiSEYzfo0=";
      };
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
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}"

        mkdir -p "$out/bin"
        ln -s "$out/share/positron/positron" "$out/bin/positron"
        runHook postInstall
      '';
    }))
    quarto
  ];

  programs.zsh.shellAliases = {
    R = "R --no-save --no-restore";
  };

  home.file.".radian_profile".source = ../../dotfiles/R/.radian_profile;
  home.file.".Rprofile".source = ../../dotfiles/R/.Rprofile;
}
