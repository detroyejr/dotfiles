default:
  just --list

setup: 
  eval $(ssh-agent) && ssh-add ~/.ssh/github_rsa

pull:
  git pull --rebase

build system:
  nixos-rebuild build --flake /home/detroyejr/.config/dotfiles#{{system}}

switch system:
  nixos-rebuild switch --flake /home/detroyejr/.config/dotfiles#{{system}}

core:
  just build xps build mini build skate

checkout-lockfile:
  git checkout origin/update_flake_lock_action --detach
  git rebase origin/main

rebase-lockfile:
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

ci: pull checkout-lockfile core rebase-lockfile
