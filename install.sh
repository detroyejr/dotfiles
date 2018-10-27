## Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## Setup vim environment
cp -r vim/. $HOME

## Install vim plugins
vim -c PluginInstall

## Add PyEnv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# Packages for pyenv.
sudo apt-get install -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    zsh


## Add .bashrc file.
cp -f bash/.bashrc $HOME/.bashrc

## Add oh-my-zsh.
## To use in Cmder for Windows, create a zsh startup task and assign:
## cmd /c C:\Windows\System32\bash.exe -c zsh ~ -new_console:p:%USERPROFILE%
cp -f zsh/.zshrc $HOME/.zshrc
