#!/bin/bash

# ZSH
sudo apt-get update \ 
    && sudo apt-get install -y 
        zsh \
        curl

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Vim
ln --force ${PWD}/vim/.vimrc ${HOME}/.vimrc

# ZSH
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln --force ${PWD}/zsh/.zshrc ${HOME}/.zshrc
ln --force ${PWD}/zsh/.p10k.zsh ${HOME}/.p10k.zsh
