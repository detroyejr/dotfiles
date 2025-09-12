{ pkgs, ... }:
let
  python-with-packages = pkgs.python3.withPackages (
    ps: with ps; [
      ipykernel
      ipython
      isort
      python-lsp-server
      python-lsp-ruff
      pylsp-mypy
    ]
  );
in
{
  environment.systemPackages = [
    python-with-packages
    pkgs.ruff
  ];
}
