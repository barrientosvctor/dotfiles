#!/bin/bash

font_user_folder="$HOME/.fonts"
font_foldername=".font-temp"
curdir=$(pwd)
font_dir="$curdir/$font_foldername"

install_font() {
    local download_url="$1"
    local font_name="$(basename ${download_url%.*})"
    local zip_name="$(basename $download_url)"

    echo "Processing $font_name..."

    mkdir -p "$font_dir" || return 1
    cd "$font_dir" || return 1

    curl -fLO "$download_url"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to download $font_name"
        return 1
    fi

    mkdir -p "$font_name"
    unzip -q "$zip_name" -d "$font_name"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to unzip $zip_name"
        return 1
    fi

    mv "$font_name" "$font_user_folder/"
    rm "$zip_name"

    echo "$font_name font installed successfully!"
    echo "---------------------------------------"
    return 0
}

# Ensure destination exists
mkdir -p "$font_user_folder"

install_font "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip"

install_font "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"

install_font "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"

# Clean up temp directory structure if empty
rm -rf "$font_dir"
