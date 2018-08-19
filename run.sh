#!/bin/bash

echo "----------Install Scipt----------"

init() {

    mkdir install-script-files

    cd install-script-files

    mkdir vars
}

varsetup() {
    echo "Setting up installation parameters"
    addspace 3

    fdisk -l
    addspace 2

    read -p "Install location: (/dev/sdX)" DRIVE
    echo "$DRIVE" > vars/drive





}

install() {
    bash "$(curl -fsSl https://raw.githubusercontent.com/cezarmathe/install-script/master/install.sh)"
}

addspace() {
    if [[ "$1" == "1" ]]; then
      echo
    elif [[ "$1" == "2" ]]; then
      echo & echo
    elif [[ "$1" == "3" ]]; then
      echo & echo $ echo
    fi
}

init

varsetup
