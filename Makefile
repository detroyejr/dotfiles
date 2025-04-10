`SHELL=/usr/bin/env`

setup:
	eval $(ssh-agent) && ssh-add ~/.ssh/github_rsa

clean:
	rm -f result

build-xps build-mini build-skate build-potato: setup
	sudo nixos-rebuild build --flake ~/.config/dotfiles#$(subst build-,,$@)

switch-xps switch-mini switch-skate switch-potato: setup
	sudo nixos-rebuild switch --flake ~/.config/dotfiles#$(subst switch-,,$@)

build-core: build-xps build-mini build-skate

git-update-lock: setup
	git checkout main && \
		git pull --rebase && \
		git rebase origin/update_flake_lock_action && \
		git push -u origin main

