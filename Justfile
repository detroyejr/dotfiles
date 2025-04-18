default:
  just --list

setup: 
  eval $(ssh-agent) && ssh-add ~/.ssh/github_rsa

pull: setup
  git pull --rebase

build system: setup
  sudo nixos-rebuild build --flake $HOME/.config/dotfiles#{{system}}

switch system: setup
  sudo nixos-rebuild switch --flake $HOME/.config/dotfiles#{{system}}

core:
  just build xps build mini build skate

checkout-lockfile: setup
  git checkout origin/update_flake_lock_action --detach
  git rebase origin/main

rebase-lockfile: setup
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

ci: pull checkout-lockfile core rebase-lockfile
