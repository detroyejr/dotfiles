# AGENTS.md

NixOS dotfiles/configuration management repository using Nix flakes.

## Project Overview

- **Primary Language**: Nix (declarative configuration)
- **Secondary Languages**: Lua (Neovim), Shell (bash/zsh), SCSS (EWW widgets)
- **Build System**: Nix Flakes
- **Platform**: NixOS (x86_64-linux)
- **Secrets**: SOPS-nix for encrypted secrets management

## Build/Test/Lint Commands

### Using Just (task runner)

```bash
just                          # List all available commands
just build <hostname>         # Build NixOS configuration
just switch <hostname>        # Apply NixOS configuration (requires sudo)
just core                     # Build all core systems (longsword, odp-1, mongoose)
just setup                    # Set up SSH agent for git
just ci                       # Full CI workflow
```

### Direct Nix Commands

```bash
nixos-rebuild build --flake .#<hostname>    # Build configuration
nixos-rebuild switch --flake .#<hostname>   # Apply configuration
nix flake check                              # Validate flake
nix flake update                             # Update all flake inputs
```

### Formatting

```bash
nix fmt                       # Format all Nix files (uses nixfmt-tree)
```

### Available Hosts

- `longsword` - Dell XPS 15 9520 (Nvidia GPU, primary workstation)
- `odp-1` - Dell OptiPlex server (services/binary cache)
- `mongoose` - Steam Deck (Jovian-NixOS)
- `scorpion` - Dell XPS 15 9570 (Nvidia GPU)
- `pelican` - Laptop

## Project Structure

```
flake.nix              # Main entry - defines all NixOS configurations
Justfile               # Task runner commands
modules/               # Reusable NixOS modules (theme, options)
nixos/
  ├── default.nix      # Base system config shared across hosts
  ├── apps/            # Application configurations
  ├── dev/             # Development environment (neovim, git, shells)
  ├── hosts/<name>/    # Per-machine configurations
  ├── hyprland/        # Window manager and desktop
  └── services/        # System services (docker, plex, etc.)
packages/              # Custom Nix package overlays
dotfiles/              # Application config files (nvim, zsh, eww)
secrets/               # SOPS-encrypted secrets
```

## Code Style Guidelines

### Nix Files

**Module Structure:**
```nix
{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./path/to/module.nix ];

  options = {
    optionName = lib.mkOption {
      type = lib.types.str;
      default = "value";
      description = "Clear description of the option.";
    };
  };

  config = { };
}
```

**Naming Conventions:**
- Nix files: `kebab-case.nix` (e.g., `binary-cache.nix`)
- Host names: lowercase single words (e.g., `longsword`, `mongoose`)
- Options: camelCase (e.g., `defaultUser`, `colorScheme`)

**Common Patterns:**
```nix
environment.systemPackages = with pkgs; [ package1 package2 ];

"http://${config.services.bindAddress}:${toString config.services.port}"

hardware.nvidia.open = lib.mkDefault config.hardware.nvidia.enabled;
```

**Overlay Structure (packages/):**
```nix
final: prev: {
  package-name = prev.stdenv.mkDerivation {
    pname = "package-name";
    version = "1.0";
    src = prev.fetchFromGitHub { ... };
    buildInputs = with final; [ dep1 dep2 ];
    installPhase = ''
      mkdir -p $out/bin
      cp binary $out/bin
    '';
  };
}
```

### Lua Files (Neovim)

**File Naming:** `snake_case.lua` for LSP configs in `dotfiles/nvim/lsp/`

**LSP Configuration Pattern:**
```lua
return {
  cmd = { 'lsp-server' },
  filetypes = { 'filetype' },
  root_markers = { '.git', 'marker.file' },
  single_file_support = true,
  settings = { },
}
```

### Shell in Nix

Use `''` for multi-line strings, escape `$` as `''$`:
```nix
pkgs.writeScriptBin "script-name" ''
  export VAR=''${BASH_VAR}
  if [ -d /path ]; then
    # action
  fi
''
```

Use `|| true` to prevent failures from stopping scripts.

## Error Handling

- Use `lib.mkDefault` for overridable defaults
- Use `lib.mkForce` to override defaults when necessary
- Use `lib.mkIf` for conditional configuration

## Notes for Agents

1. **Don't modify secrets**: `secrets/secrets.yaml` is SOPS-encrypted
2. **Test builds**: Use `just build <hostname>` before applying changes
3. **Format code**: Run `nix fmt` before committing Nix changes
4. **Respect option types**: Check `lib.types.*` when modifying options
5. **Hardware-specific code**: Use `config.hardware.nvidia.enabled` for GPU-specific config
6. **System state**: `system.stateVersion` should NOT be changed on existing hosts
