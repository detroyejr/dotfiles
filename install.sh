#!/bin/bash

# Pyenv
sudo apt-get update \ 
    && sudo apt-get install -y 
        make \
        build-essential \
        libssl-dev zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget curl llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Vim
ln --force ${PWD}/vim/.vimrc ${HOME}/.vimrc

# ZSH
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln --force ${PWD}/zsh/.zshrc ${HOME}/.zshrc

