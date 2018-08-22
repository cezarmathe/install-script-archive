#!/bin/bash

PKG_LIST_NATIVE='packages.txt'


install_native_packages() {
    pacman -Syy --noconfirm
    pacman --needed --noconfirm -S - < packages.txt
}


if [[ "$1" == "native" ]]; then
    install_native_packages
fi
