{ pkgs, ... }:

let
  python-with-packages = pkgs.python310.withPackages (ps: with ps; [
    black
    boto3
    dask
    dbus-python
    flake8
    ipython
    isort
    lxml
    material-color-utilities
    mpd2
    pandas
    pillow
    pip
    pygobject3
    pytest
    python-lsp-server
    requests
    s3fs
    sqlalchemy
    wand
  ]);
in
{
  home.packages = [ python-with-packages pkgs.poetry pkgs.gtk3 pkgs.gobject-introspection pkgs.ruff ];
}
