#!/bin/sh

$curdir=$(pwd)

cd $HOME

git clone --depth=1 https://github.com/barrientosvctor/dotfiles.git $HOME/.dotfiles

chmod +x $HOME/.dotfiles/bootstrap-termux.sh
$HOME/.dotfiles/bootstrap-termux.sh

cd $curdir