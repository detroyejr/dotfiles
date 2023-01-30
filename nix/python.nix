{ pkgs, lib, ... }:

let
  python = pkgs.python310;
  python-with-packages = python.withPackages (p: with p; [
    black
    dask
    ipython
    lxml
    pandas
    pip
    pytest
    python-lsp-server  
    requests
    s3fs
]);
in
{
  home.packages = [ python-with-packages ];
}
