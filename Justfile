default:
  just --list

setup: 
  eval $(ssh-agent) && ssh-add ~/.ssh/github_rsa

build-keep-going system:
  nixos-rebuild build --keep-going --flake /home/detroyejr/.config/dotfiles#{{system}}

build-local system:
  nixos-rebuild build --option builders "" --flake /home/detroyejr/.config/dotfiles#{{system}} 

build system:
  nixos-rebuild build --flake /home/detroyejr/.config/dotfiles#{{system}}

switch system:
  nixos-rebuild switch --flake /home/detroyejr/.config/dotfiles#{{system}}

core:
  just \
    build-keep-going longsword \
    build-keep-going odp-1 \
    build-keep-going mongoose \
    build-keep-going pelican \
    build-keep-going razorback \
    build-local longsword \
    build-local odp-1 \
    build-local mongoose \
    build-local pelican \
    build-local razorback \


checkout-initial:
  git checkout main

pull:
  git pull --rebase

checkout-lockfile:
  git checkout origin/update_flake_lock_action --detach
  git rebase origin/main

rebase-lockfile:
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

stash:
  git stash

stash-apply:
  git stash apply

cleanup:
  rm result

ci: stash checkout-initial pull checkout-lockfile core cleanup rebase-lockfile stash-apply

# Upgrade after nix profile add --impure.
profile:
  nix profile upgrade dotfiles
