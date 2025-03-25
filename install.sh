#!/bin/bash

folder_path=$(pwd)

# GLOBAL FUNCTIONS
setup_vimrc() {
	git clone https://github.com/barrientosvctor/vimrc.git ~/.vim
	cd ~/.vim
	make
}

setup_nvimrc() {
	git clone https://github.com/barrientosvctor/nvim.git ~/.config/nvim
	cd ~/.config/nvim
	chmod +x ./scripts/actions.sh
    ./scripts/actions.sh 1
}

symlink_dotfiles() {
	ln -s ${folder_path}/.bashrc ~/.bashrc
	ln -s ${folder_path}/.bash_logout ~/.bash_logout
	ln -s ${folder_path}/.editorconfig ~/.editorconfig
	ln -s ${folder_path}/.prettierrc.json ~/.prettierrc.json
	ln -s ${folder_path}/.gitconfig ~/.gitconfig
	ln -s ${folder_path}/.tmux.conf ~/.tmux.conf
}


# UNIX INSTALLATIONS
install_vim_from_source() {
	sudo apt-get install lua5.1 liblua5.1-dev make libxt-dev libgtk-3-dev

	git clone https://github.com/vim/vim.git ~/vim
	cd ~/vim

	./configure --with-features=huge \
            --enable-cscope \
            --enable-multibyte \
            --enable-fontset \
            --enable-gui=gtk3 \
            --disable-netbeans \
            --enable-luainterp=yes
	make && sudo make install
}

install_packages() {
	# CMake also includes c (cc, gcc) and c++ (g++, c++) compilers.
	sudo apt install git tmux cmake
	echo "Installed packages: git, tmux, cmake"
}

# TERMUX FUNCTIONS
function termux_packages {
    pkg update
    pkg install git tmux cmake nodejs-lts
}

function termux_vim_install {
    pkg install vim
}

function termux_neovim_install {
    pkg install neovim
}

case "$1" in
    packages)
        install_packages
        ;;
    symlink)
        symlink_dotfiles
        ;;
    vim.install)
        install_vim_from_source
        ;;
    vim.rc)
        setup_vimrc
        ;;
    nvim.rc)
        setup_nvimrc
        ;;
    all)
        install_packages
        install_vim_from_source
        setup_vimrc
        symlink_dotfiles
        ;;
    termux.packages)
        termux_packages
        ;;
    termux.vim)
        termux_vim_install
        setup_vimrc
        ;;
    termux.nvim)
        termux_neovim_install
        setup_nvimrc
        ;;
    termux.all)
        # Creates the 'storage' folder
        termux-setup-storage
        termux_packages
        termux_vim_install
        setup_vimrc
        symlink_dotfiles
        ;;
    *)
        echo -e "\nUsage: $(basename "$0") {packages|symlink|vim.install|vim.rc|nvim.rc|termux.packages|termux.vim|termux.nvim|termux.all|all}\n"
        exit 1
        ;;
esac

echo "Done."
