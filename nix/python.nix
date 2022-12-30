{ pkgs, lib, ... }:

let
  python = pkgs.python310;
  python-with-packages = python.withPackages (p: with p; [
    pandas
    requests
    ipython
    pytest
    dask
    black
    python-lsp-server  
]);
in
{
  home.packages = [ python-with-packages ];
}
