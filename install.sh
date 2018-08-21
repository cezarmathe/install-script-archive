# !/bin/bash

# Params
DRIVE=''

BOOTLOADER_DRIVE=''

PARTITION_NUMBER=''

HOSTNAME=''

ROOT_PASSWORD=''

USER_NAME=''

USER_PASSWORD=''

TIMEZONE=''

# VIDEO_DRIVER="nouveau"
#
# WIRELESS_DEVICE="wlan0"

PARTITION_START=''

PARTITION_END=''


params_setup() {
    DRIVE=`cat vars/DRIVE`
    BOOTLOADER_DRIVE=`cat vars/BOOTLOADER_DRIVE`
    PARTITION_NUMBER=`cat vars/PARTITION_NUMBER`
    PARTITION_START=`cat vars/PARTITION_START`
    PARTITION_END=`cat vars/PARTITION_END`
    HOSTNAME=`cat vars/HOSTNAME`
    ROOT_PASSWORD=`cat vars/ROOT_PASSWORD`
    TIMEZONE=`cat vars/TIMEZONE`
    USER_NAME=`cat vars/USER_NAME`
    USER_PASSWORD=`cat vars/USER_PASSWORD`
}


setup() {

    local drive="$DRIVE$PARTITION_NUMBER"

    echo "Creating partition"
    create_partition "$DRIVE"

    echo "Formatting filesystem"
    format_partition "$drive"

    echo "Mounting the filesystem"
    mount_filesystem "$drive"

    echo "Installing the base system"
    install_base_system

    echo "Creating the swapfile"
    create_swap

    echo "Setting the fs tab"
    set_fstab

    echo "Changing root to continue with system configuration"
    cp $0 /mnt/install.sh
    cp pkg-install.sh /mnt/pkg-install.sh
    cp -r vars /mnt/vars
    arch-chroot /mnt ./install.sh configuration

    arch-chroot /mnt ./install.sh native

    arch-chroot -u "$USER_NAME" /mnt ./install.sh aurman

    arch-chroot /mnt ./install.sh aur

    post_install

    if [ -f /mnt/install.sh ]
    then
        echo 'Error inside chroot'
    else
        echo 'Unmounting filesystems'
        unmount_filesystem
        echo 'Done! Reboot your system using reboot'
    fi

}


config() {

    local drive="$DRIVE"1

    echo "Setting the hostname"
    set_hostname

    echo "Setting the hosts"
    set_hosts

    echo "Setting the locale"
    set_locale

    echo "Setting the timezone"
    set_timezone

    echo "Syncing hardware clock"
    sync_hwclock

    echo "Configuring the bootloader"
    config_bootloader

    echo "Configuring sudo"
    config_sudo

    echo "Changing the root password"
    root_passwd

    echo "Creating the initial user"
    create_user

}



post_install() {
    rm install.sh
    rm pkg-install.sh
    rm -r vars
}


install_native_packages() {
    pacman --noconfirm -Syy
    pacman -S git --needed --noconfirm
    read -p "Do you want to install native packages from a package list?(y/n): " yn
    case $yn in
        [Yy]* ) read -p "Enter the URL where the package list is located:" URL
                curl -L "$URL" -o packages.txt
                # read -p "If the file name is diffrent than packages.txt, enter the name: "  NAME
                # if [[ -z "$NAME" ]]; then
                #     ./pgk-install.sh native
                # else
                #     ./pkg-install.sh native "$NAME"
                # fi
                ./pkg-install.sh native
                exit
                break;;

        [Nn]* ) echo "Skipping"
                break;;
    esac
}


install_aurman() {
    read -p "Do you want to install aurman?(y/n): " yn
    case $yn in
        [Yy]* ) ./pkg-install.sh aurman
                break;;
        [Nn]* ) echo "Skipping"
    esac
}


install_aur_packages() {
    read -p "Do you want to install aur packages from a package list?(y/n): " yn
    case $yn in
        [Yy]* ) read -p "Enter the URL where the package list is located:" URL
                curl -L "$URL" -o packages-aur.txt
                read -p "If the file name is diffrent than packages-aur.txt, enter the name: "  NAME
                # if [[ -z "$NAME" ]]; then
                #     ./pkg-install.sh aur
                # else
                #     ./pkg-install.sh aur "$NAME"
                # fi
                ./pkg-install.sh aur
                break;;

        [Nn]* ) echo "Skipping"
                break;;
    esac
}


set_hostname() {
    echo "$HOSTNAME" > /etc/hostname
}


set_hosts() {
    echo "127.0.0.1       localhost" > /etc/hosts
    echo "::1             localhost" >> /etc/hosts
    echo "127.0.1.1       $HOSTNAME.localdomain       $HOSTNAME" >> /etc/hosts
}


set_timezone() {
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
}


set_locale() {
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    locale-gen
}


set_fstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
}


config_bootloader() {
    pacman -Syy --noconfirm
    pacman -S grub os-prober --noconfirm
    grub-install --target=i386-pc "$BOOTLOADER_DRIVE"
    grub-mkconfig -o /boot/grub/grub.cfg
}


config_sudo() {
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
}


sync_hwclock() {
    hwclock --systohc
}


create_swap() {
    fallocate -l 4G /mnt/swapfile
    chmod 600 /mnt/swapfile
    mkswap /mnt/swapfile
    swapon /mnt/swapfile
}


install_base_system() {
    pacstrap -i /mnt base base-devel
}


create_partition() {
    local part="$1"; shift

    parted -s "$part" \
        mklabel msdos \
        mkpart primary ext4 "$PARTITION_START" "$PARTITION_END" \
        set 1 boot on
}


format_partition() {
    local part="$1"; shift
    mkfs.ext4 "$part"
}


mount_filesystem() {
    local fs="$1"; shift
    mount "$fs" /mnt
}


unmount_filesystem() {
    umount /mnt
}


create_user() {
    useradd -G power,storage,wheel -m "$USER_NAME"
    echo -en "$USER_PASSWORD\n$USER_PASSWORD" | passwd "$USER_NAME"

}


root_passwd() {
    echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
}



params_setup

if [ "$1" == "configuration" ]; then
    config
elif [[ "$1" == "native" ]]; then
    install_native_packages
elif [[ "$1" == "aurman" ]]; then
    install_aurman
elif [[ "$1" == "aur" ]]; then
    install_aur_packages
else
    setup
fi
