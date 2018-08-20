#!/bin/bash

PKG_LIST_NATIVE='packages.txt'

PKG_LIST_AUR='packages-aur.txt'


install_native_packages() {
    pacman -Syy --no-confirm
    pacman --needed --no-confirm -S - < packages.txt
}

install_aurman() {
    git clone https://aur.archlinux.org/aurman.git
    cd aurman
    makepkg -si
    cd ..
    rm aurman
}

install_aur_packages() {
    aurman -S - < packages-aur.txt
}


if [[ "$1" == "native" ]]; then
    if [[ -z "$2" ]]; then
        echo "Installing native packages from text file $PKG_LIST_NATIVE"
        install_native_packages
    else
        PKG_LIST_NATIVE="$2"
        echo "Installing native packages from text file $PKG_LIST_NATIVE"
        install_native_packages
    fi
elif [[ "$2" == "aurman" ]]; then
    install_aurman
elif [[ "$3" == "aur" ]]; then
    if [[ -z "$2" ]]; then
        echo "Installing aur packages from text file $PKG_LIST_AUR"
        install_aur_packages
    else
        PKG_LIST_AUR="$2"
        echo "Installing aur packages from text file $PKG_LIST_AUR"
        install
    fi
fi
