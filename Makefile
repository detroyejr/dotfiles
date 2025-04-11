`SHELL=/usr/bin/env`

NAME := $(shell uname -n)

start-ssh-agent:

	eval $(ssh-agent -s)

add-key:
	ssh-add ~/.ssh/github_rsa

setup: start-ssh-agent add-key

clean:
	rm -f result

switch build:
	@echo "Executing nixos-rebuild $@ for $(NAME)"
	@case $(NAME) in \
		XPS-Nixos) \
			sudo nixos-rebuild $@ --flake ~/.config/dotfiles#xps \
			;; \
		mini-1) \
			sudo nixos-rebuild $@ --flake ~/.config/dotfiles#mini \
			;; \
		potato) \
			sudo nixos-rebuild $@ --flake ~/.config/dotfiles#potato \
			;; \
		skate) \
			sudo nixos-rebuild $@ --flake ~/.config/dotfiles#skate \
			;; \
		*) \
			exit 1 \
			;; \
	esac

build-xps build-mini build-skate build-potato:
	sudo nixos-rebuild build --flake ~/.config/dotfiles#$(subst build-,,$@)

build-core: build-xps build-mini build-skate

git-update-lock: setup
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

ci: setup build-core git-update-lock
