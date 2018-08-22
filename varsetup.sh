#!/bin/bash

init() {

    mkdir vars
}

var_setup() {
    echo "Setting up installation parameters"
    add_space 3

    fdisk -l
    add_space 2

    var "Install location (/dev/sdX): " DRIVE

    var "Bootloader location (/dev/sdY): " BOOTLOADER_DRIVE

    var "Partition number (1,2 etc): " PARTITION_NUMBER

    var "Partition start (1 for the beggining of the drive, 100M=100MB, look in fdisk): " PARTITION_START

    var "Partition end (100% will assign the rest of the drive, +100M will allocate the next 100 MB): " PARTITION_END

    var "Root password: " ROOT_PASSWORD password

    var "Additional user name: " USER_NAME

    var "Additional user password: " USER_PASSWORD password

    var "Hostname: " HOSTNAME

    var "Timezone (Region/City i.e. Europe/Bucharest): " TIMEZONE

    chmod 777 *

    add_space 3

    echo "Starting the installation process"

    add_space 1
}

var() {
    if [[ "$3" == "password" ]]; then
        read -s -p "$1" TEMP_VAR
        echo "$TEMP_VAR" > "vars/$2"
        add_space 1
    else
        read -p "$1" TEMP_VAR
        echo "$TEMP_VAR" > "vars/$2"
        add_space 1
    fi
}

add_space() {
    if [[ "$1" == "1" ]]; then
      echo
    elif [[ "$1" == "2" ]]; then
      echo & echo
    elif [[ "$1" == "3" ]]; then
      echo & echo & echo
    fi
}

init

var_setup
