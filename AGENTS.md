# Repository guidance

- Dotfiles are managed with with nix, specifically the `flake.nix` and
  `flake.lock` files.

- There are 5 main folders organizing the repo: 
    1) `dotfiles` has application specific configuration.
    2) `modules` holds the nix configuration files for applications (apps),
    services (services), and developer tooling (dev). 
    3) `hosts` contains each device or host that we will want to build using
    nixos-rebuild. 
    4) `packages` has the overlays that override the defaults in nixpkgs. These
    are defined when `import nixpkgs ...` is  evaluated.

- The `Justfile` defines the commands that I run most often, including recipes
  to build, activate host configurations, and remote building.

- `nix fmt` applies the flake formatter (`nixfmt-tree`). No test or lint suite
  is defined; the GitHub workflow only updates `flake.lock`.

- Do not use `just switch` or `just boot` as checks: they activate the current
  host configuration. `just ci` also stashes/checks out branches, rebases and
  pushes, and removes `result`; only run it when explicitly requested.

- `secrets/secrets.yaml` is SOPS-encrypted. `.envrc` loads the age key from
  `~/.ssh/main_server_ed25519`; do not print or commit decrypted secrets.
  Preserve `flake.lock` unless changing dependencies.

- Always follow commit conventions when writing commits. Write one commit per
  change for each program using the message template `<program/service>: <what
  changed>`. The following are examples of good commit messages:
    * hyprland: remove stale swaync binding
    * omarchy: disable notifications daemon
    * neovim: use patched opencode plugin
    * alloy: enable systemd compression
    * bookorbit: sync annotations with obsidian
    * flake: bump flake.lock

- If available use existing service and program options. e.g. Prefer
  `programs.localsend.enable = true` over
  `users.users.${defaultUser}.packages = [ localsend ];`
