## Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## Setup vim environment
cp -r vim/. $HOME

## Install vim plugins
vim -c PluginInstall

## Add PyEnv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

## Add .bashrc file.
cp -f bash/.bashrc $HOME/.bashrc
