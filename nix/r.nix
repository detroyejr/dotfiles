{ pkgs, lib, ... }:

with pkgs;
let
 R-with-packages = rWrapper.override{ 
   packages = with rPackages; [ 
     ggplot2 
     dplyr
     httr
     languageserver
   ]; 
};
in
{
  home.packages = [ R-with-packages ];
}
