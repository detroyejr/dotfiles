{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs;
let
  cfg = config.programs.r;

  R-with-packages = rWrapper.override {
    packages =
      with rPackages;
      let
        surveytools = buildRPackage {
          name = "EchelonSurveyTools";
          src = builtins.fetchGit {
            url = "git@github.com:EchelonInsights/EchelonSurveyTools.git";
            rev = "40cda13a38d2033b019ef2b047f2950655d45e22";
            allRefs = true;
          };
          buildInputs = [
            RMariaDB
            RPostgres
            haven
            httr2
            jsonlite
            pkgs.R
            relaimpo
            scales
            sjlabelled
            stringi
            tibble
            xml2
          ];
        };
        topline = buildRPackage {
          name = "Topline";
          src = builtins.fetchGit {
            url = "git@github.com:echeloninsights/topline.git";
            rev = "c87451486803cb1ce023aa5e414cb584b74ce776";
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
        ggplot2
        googledrive
        googlesheets4
        haven
        httpuv
        httr
        huxtable
        jsonlite
        magick
        officer
        readxl
        relaimpo
        reticulate
        sf
        sjlabelled
        stringi
        surveytools
        topline
        usethis
        xml2
      ];
  };
in
{
  options.programs.r.enable = lib.mkEnableOption "R development environment";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      R-with-packages
      ark-posit
      air-formatter
      jarl
      pandoc
    ];

    environment.etc = {
      "xdg/R/.Rprofile".source = ../../dotfiles/R/.Rprofile;
    };

    environment.sessionVariables = {
      R_PROFILE = "/etc/xdg/R/.Rprofile";
    };

    programs.zsh.shellAliases = {
      R = "R --no-restore";
    };
  };
}
