# !/bin/bash

# echo "Setting ntp true"
# timedatectl set-ntp true
#
# echo "Ext4 formatting"
# mkfs.ext4 /dev/sda1
#
# echo "Mounting.."
# mount /dev/sda1 /mount
#
# echo "Installing base and base-devel"
# pacstrap /mnt base base-devel
#
# echo "Generating fs tab"
# genfstab -U /mnt >> /mnt/etc/fstab
#
# cp packages.txt /mnt/packages.txt
# cp post-install.sh /mnt/post-install.sh
# arch-chroot /mnt post-install.sh


DRIVE='/dev/sda'

PARTITION_NUMBER=1

HOSTNAME='cezar-PC'

ROOT_PASSWORD='password'

USER_NAME='username'

USER_PASSWORD='password'

TIMEZONE='Europe/Bucharest'

VIDEO_DRIVER="nouveau"

WIRELESS_DEVICE="wlan0"


setup() {

    local drive="$DRIVE"1

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

    echo "Changing root to continue installation"
    cp $0 /mnt/setup.sh
    arch-chroot /mnt ./setup.sh configuration

    if [ -f /mnt/setup.sh ]
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

    echo "Installing packages"
    # install_packages

    echo "Installing aurman"
    # install_aurman

    echo "Installing AUR packages"
    # install_aur_packages

    echo "Changing the root password"
    root_passwd

    echo "Creating the initial user"
    create_user

    rm /setup.sh

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
    pacman -S grub --noconfirm
    grub-install --target=i386-pc "$DRIVE"
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
        mkpart primary ext4 1 100% \
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
    useradd --create-home -G power,storage,wheel "$USER_NAME"
    echo -en "$USER_PASSWORD\n$USER_PASSWORD" | passwd "$USER_NAME"

}


root_passwd() {
    echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
}



if [ "$1" == "configuration" ]
then
    config
else
    setup
fi
