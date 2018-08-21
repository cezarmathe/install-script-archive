#!/bin/bash

PKG_LIST_NATIVE='packages.txt'

PKG_LIST_AUR='packages-aur.txt'


install_native_packages() {
    pacman -Syy --noconfirm
    pacman --needed --noconfirm -S - < packages.txt
}

install_aurman() {
    git clone https://aur.archlinux.org/aurman.git
    cd aurman
    makepkg -si
    cd ..
    rm -r aurman
}

install_aur_packages() {
    aurman --needed --noconfirm -S - < packages-aur.txt
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
elif [[ "$1" == "aurman" ]]; then
    install_aurman
elif [[ "$1" == "aur" ]]; then
    if [[ -z "$2" ]]; then
        echo "Installing aur packages from text file $PKG_LIST_AUR"
        install_aur_packages
    else
        PKG_LIST_AUR="$2"
        echo "Installing aur packages from text file $PKG_LIST_AUR"
        install
    fi
fi
