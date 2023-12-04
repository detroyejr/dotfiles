{ pkgs, lib, ... }:

with pkgs;
let
  R-with-packages = rWrapper.override{ 
    # Expose R packages when using radian.
    # wrapR = true;
    packages = with rPackages; let
      surveytools = buildRPackage {
        name = "EchelonSurveyTools";
        src = builtins.fetchGit {
          url = "git@github.com:echeloninsights/EchelonSurveyTools.git";
          rev = "f54ea92a1828d82c2eb4a9b18f37119060ff71e6";
        };
        buildInputs = [ 
          RMariaDB 
          RPostgres 
          huxtable 
          knitr 
          magick 
          pkgs.R 
          relaimpo 
          rmarkdown 
          scales 
          sjlabelled 
          tibble 
        ];
      };
      topline = buildRPackage {
        name = "Topline";
        src = builtins.fetchGit {
          url = "git@github.com:echeloninsights/topline.git";
          rev = "baf299360113e13a02b0bbb58cf2a4119dcc5726";
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
    in [
      PracTools
      RMariaDB
      RPostgres
      data_table
      dplyr
      flextable
      ftExtra
      ggplot2
      googledrive
      haven
      httr
      huxtable
      knitr
      languageserver
      magick
      officer
      quarto
      readxl
      relaimpo
      reticulate
      rmarkdown
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
  home.packages = [ R-with-packages pandoc quarto ];

  programs.zsh.shellAliases = {
    R = "R --no-save --no-restore";
  };

  home.file.".radian_profile".source = ../../dotfiles/R/.radian_profile;
  home.file.".Rprofile".source = ../../dotfiles/R/.Rprofile;
}

