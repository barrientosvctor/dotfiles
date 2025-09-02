#!/bin/sh

termux-setup-storage

pkg --check-mirror update
pkg update && pkg upgrade --yes

pkg install vim tmux git wget fzf nodejs-lts -y

ln --force -s $HOME/.dotfiles/.config/vim/.vimrc $HOME/.vimrc
ln --force -s $HOME/.dotfiles/.config/tmux/.tmux.conf $HOME/.tmux.conf

# Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"