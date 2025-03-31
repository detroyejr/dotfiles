#! /usr/bin/env nix-shell
#! nix-shell -i bash --packages bash gh git

eval $(ssh-agent)
ssh-add ~/.ssh/github_rsa ~/.ssh/mini_rsa

git checkout origin/update_flake_lock_action --detach
git rebase origin/main

if [[ $(git log --oneline | grep $(git log --pretty --oneline -n 1 | awk '{ print $1 }') | wc -l) -gt 0 ]]; then
  for system in xps mini potato skate; do
    nix build .#nixosConfigurations.${system}.config.system.build.toplevel --builders "ssh://detroyejr@mini-2?ssh-key=/home/detroyejr/.ssh/mini_rsa;ssh://detroyejr@mini-3?ssh-key=/home/detroyejr/.ssh/mini_rsa;ssh://detroyejr@mini-4?ssh-key=/home/detroyejr/.ssh/mini_rsa;ssh://detroyejr@mini-5?ssh-key=/home/detroyejr/.ssh/mini_rsa"
    nixos-rebuild build --flake $HOME/.config/dotfiles#${system}
    exit_code=$?
    [[ $exit_code == 1 ]] && exit 1
  done
fi;

# Merge
git checkout main && \
  git pull --rebase && \
  git rebase origin/update_flake_lock_action && \
  git push -u origin main
rm -r result

