
default:
  just --list

setup: 
  eval $(ssh-agent) && ssh-add ~/.ssh/github_rsa

build system: setup
  sudo nixos-rebuild build --flake $HOME/.config/dotfiles#{{system}}

switch system: setup
  sudo nixos-rebuild build --flake $HOME/.config/dotfiles#{{system}}

core:
  just build xps build mini build skate
  just git-update-lock

git-update-lock: setup
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

