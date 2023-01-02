{ pkgs, lib, ... }:

with pkgs;
let
 R-with-packages = rWrapper.override{ 
   packages = with rPackages; [ 
     data_table
     haven
     httr
     languageserver
     sjlabelled
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


