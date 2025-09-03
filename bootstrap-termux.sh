#!/bin/bash -

set -x

# Returns the dotfiles' path from wherever directory you run this script.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

termux-setup-storage

pkg --check-mirror update
pkg update && pkg upgrade --yes

pkg install vim tmux git wget fzf nodejs-lts --yes

ln --force -s $DOTFILES_DIR/.config/vim/.vimrc $HOME/.vimrc
ln --force -s $DOTFILES_DIR/.config/tmux/.tmux.conf $HOME/.tmux.conf

# Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"