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
          rev = "11f31b92fff66234e5e1fbb23f1e8dac23d477c6";
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
          rev = "9907459cfdde73a5a565aee0cbafced29e086aa7";
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

