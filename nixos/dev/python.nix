{ pkgs, ... }:
let
  python-with-packages = pkgs.python3.withPackages (
    ps: with ps; [
      aioboto3
      boto3
      boto3-stubs
      cookiecutter
      fsspec
      ipykernel
      isort
      mypy-boto3-builder
      pandas
      pandas-stubs
      pylsp-mypy
      pyreadstat
      pytest
      pytest-asyncio
      python-lsp-ruff
      python-lsp-server
      pyyaml
      redshift-connector
      requests
      s3fs
      voter_match
    ]
  );
  voter_match = pkgs.python3Packages.buildPythonPackage {
    name = "voter_match";
    src = "${
      builtins.fetchGit {
        url = "git@github.com:echeloninsights/actions.git";
        rev = "4fb874524613576a2f4c0de33bb80549932008d6";
        allRefs = true;
      }
    }/voter_match";
    buildInputs = with pkgs.python3Packages; [ setuptools ];
    format = "pyproject";
  };
in
{
  environment.systemPackages = [
    pkgs.basedpyright
    pkgs.ruff
    python-with-packages
  ];
}
