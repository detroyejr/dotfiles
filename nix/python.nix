{ pkgs, lib, ... }:

let
  python = pkgs.python310;
  python-with-packages = python.withPackages (p: with p; [
    black
    boto3
    dask
    ipython
    lxml
    pandas
    pip
    python-lsp-server
    pytest
    requests
    s3fs
    sqlalchemy
]);
in
{
  home.packages = [ python-with-packages pkgs.ruff ];
}
