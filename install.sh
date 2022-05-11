#!/bin/bash

# ZSH
sudo apt-get update && \
    sudo apt-get install -y 
        zsh \
        curl

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Vim
ln --force ${PWD}/vim/.vimrc ${HOME}/.vimrc

# ZSH
FOLDER=$(dirname ${BASH_SOURCE[0]})
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln --force ${FOLDER}/zsh/.zshrc ${HOME}/.zshrc
ln --force ${FOLDER}/zsh/.p10k.zsh ${HOME}/.p10k.zsh
