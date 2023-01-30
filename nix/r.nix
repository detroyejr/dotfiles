{ pkgs, lib, ... }:

with pkgs;
let
  R-with-packages = rWrapper.override{ 
    packages = with rPackages; let
      surveytools = buildRPackage {
        name = "EchelonSurveyTools";
        src = builtins.fetchGit {
          url = "git@github.com:echeloninsights/EchelonSurveyTools.git";
          rev = "33aae7b5303bc21c21e2e4bf1b9d76f8f349b195";
        };
      buildInputs = [ 
        pkgs.R 
        RMariaDB 
        RPostgres 
        huxtable 
        knitr 
        magick 
        relaimpo 
        rmarkdown 
        scales 
        sjlabelled 
        tibble 
      ];
    };
    in [
      RMariaDB
      RPostgres
      data_table
      dplyr
      haven
      httr
      huxtable
      knitr
      languageserver
      magick
      relaimpo
      sjlabelled
      surveytools
      usethis
    ];
  };
in
{
  home.packages = [ R-with-packages ];

  programs.zsh.shellAliases = {
    R = "R --vanilla";
  };
}

