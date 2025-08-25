#!/bin/sh -

curdir=$(pwd)

# Checks if vim command is not on path to install it.
if ! command -v vim >/dev/null 2>&1
then
	sudo apt install vim
fi

ln -s $curdir/.config/vim/.vimrc $HOME/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"
