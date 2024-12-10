{ pkgs, ... }:
let
  pyechelon = pkgs.python3Packages.buildPythonPackage {
    name = "echelon";
    src = builtins.fetchGit {
      url = "git@github.com:echeloninsights/pyechelon.git";
      rev = "b46dc8fca966e829b86502491a025475fd135405";
      allRefs = true;
    };
    method = "pyproject";
    buildInputs = with pkgs.python3Packages; [
      pip
      setuptools
      sqlalchemy
      redshift-connector
      slackclient
    ];
    doCheck = false;
    patchHook = ''
      replace $src/pyproject.toml ./pyproject.toml \
        --replace-warn "slackclient = \"^2.9.4\"" ""

      replace $src/requirements.txt ./requirements.txt \
        --replace-warn "slackclient==2.9.2" ""
    '';
  };
  python-with-packages = pkgs.python3.withPackages (
    ps: with ps; [
      black
      boto3
      dask
      dbus-python
      flake8
      ipython
      ipykernel
      isort
      lxml
      material-color-utilities
      mpd2
      pandas
      pillow
      pip
      # pyechelon
      pygobject3
      pytest
      python-lsp-server
      redshift-connector
      requests
      s3fs
      sqlalchemy
      wand
    ]
  );
in
{
  home.packages = [
    python-with-packages
    pkgs.ruff
  ];
}
