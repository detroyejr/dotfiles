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
          rev = "33aae7b5303bc21c21e2e4bf1b9d76f8f349b195";
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
    in [
      PracTools
      RMariaDB
      RPostgres
      data_table
      dplyr
      ggplot2
      haven
      httr
      huxtable
      knitr
      languageserver
      magick
      readxl
      relaimpo
      sf
      sjlabelled
      surveytools
      usethis
    ];
  };
in
{
  home.packages = [ R-with-packages ];

  programs.zsh.shellAliases = {
    R = "R --no-save --no-restore";
  };

  home.file."/home/detroyejr/.radian_profile".source = ../R/.radian_profile;
  home.file."/home/detroyejr/.Rprofile".source = ../R/.Rprofile;
}

