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
            rev = "676d0e326cc1a7850c17f0c169f9b09d475443ab";
            allRefs = true;
          };
          buildInputs = [
            RMariaDB
            RPostgres
            haven
            httr2
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
        googledrive
        googlesheets4
        haven
        httr
        huxtable
        magick
        officer
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
  environment.systemPackages = [
    R-with-packages
    ark-posit
    air-formatter
    pandoc
  ];

  environment.etc = {
    "xdg/R/.Rprofile".source = ../../dotfiles/R/.Rprofile;
  };

  environment.sessionVariables = {
    R_PROFILE = "/etc/xdg/R/.Rprofile";
  };

  programs.zsh.shellAliases = {
    R = "R --no-save --no-restore";
  };
}
