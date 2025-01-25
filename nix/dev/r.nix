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
        # topline
        # usethis
      ];
  };
in
{
  home.packages = [
    R-with-packages
    ark-posit
    # air-posit
    # pandoc
    # positron-bin
    # quarto
  ];

  programs.zsh.shellAliases = {
    R = "R --no-save --no-restore";
  };

  home.file.".radian_profile".source = ../../dotfiles/R/.radian_profile;
  home.file.".Rprofile".source = ../../dotfiles/R/.Rprofile;
}
