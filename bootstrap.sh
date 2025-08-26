#!/bin/sh -

curdir=$(pwd)

# ---------------------- Fzf installation ----------------------
# Checks if fzf command is not on path to install it.
if ! command -v fzf >/dev/null 2>&1
then
	sudo apt install fzf
fi

# ---------------------- Vim(rc) installation ----------------------
if ! command -v vim >/dev/null 2>&1
then
	sudo apt install vim
fi

ln -s $curdir/.config/vim/.vimrc $HOME/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"

# ---------------------- Node.js installation ----------------------
if ! command -v node >/dev/null 2>&1
then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    nvm install --lts
    nvm use --lts
fi

# ---------------------- Symlinks setup ----------------------
rm -rf $HOME/.tmux.conf
ln -s $curdir/.config/tmux/.tmux.conf $HOME/.tmux.conf
