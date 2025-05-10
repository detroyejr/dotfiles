{ pkgs, ... }:
let
  python-with-packages = pkgs.python3.withPackages (
    ps: with ps; [
      black
      flake8
      ipykernel
      ipython
      isort
      python-lsp-server
    ]
  );
in
{
  environment.systemPackages = [
    python-with-packages
    pkgs.ruff
  ];
}
