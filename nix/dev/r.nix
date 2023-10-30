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
          rev = "5060b772d1df378e7aa637e09da0101415062108";
        };
        buildInputs = with rPackages; [ 
          flextable
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

