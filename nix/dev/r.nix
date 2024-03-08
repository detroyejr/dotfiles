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
          allRefs = true;
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
          rev = "751a269c990053c0b9f5f5ce72259f3e6934bf8a";
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

