#!/bin/bash

unlink_symlinks ()
{
    echo "------ Unlinking symlinks... ------"
    unlink ~/.bashrc
    unlink ~/.bash_profile
    unlink ~/.zshrc
    unlink ~/.editorconfig
    unlink ~/.prettierrc.json
    unlink ~/.tmux.conf
    echo "------ Symlinks successfully unlinked ------"
}

uninstall_vim ()
{
    echo "------ Uninstalling VIM... ------"
    apt --purge autoremove vim

    echo "------ Removing Vimrc... ------"
    rm -rf ~/.vim
    echo "------ VIM uninstallation done ------"
}

main ()
{
    unlink_symlinks
    uninstall_vim
}

main
