#! /usr/bin/env nix-shell
#! nix-shell -i bash --packages bash gh

eval $(ssh-agent)
ssh-add ~/.ssh/github_rsa

gh pr checkout flake_lock_update_action

nixos-rebuild build --flake $HOME/.config/dotfiles#xps
nixos-rebuild build --flake $HOME/.config/dotfiles#mini
nixos-rebuild build --flake $HOME/.config/dotfiles#potato

rm -r result

