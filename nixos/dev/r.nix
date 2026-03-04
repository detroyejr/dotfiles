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
            url = "git@github.com:EchelonInsights/EchelonSurveyTools.git";
            rev = "3318011607fede5786de2f8db4c8c975982c51b4";
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
            rev = "c0b96d8ae14b58e0be6b2a5ad3a6af13bf58d5fb";
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
}
