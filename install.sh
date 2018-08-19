# !/bin/bash

# echo "Setting ntp true"
# timedatectl set-ntp true
#
# echo
# echo "Partitions:"
# fdisk -l
#
# echo "Create partitions:"
#
# cfdisk
#
# echo "Write the partition where arch should be installed"

echo "Setting ntp true"
timedatectl set-ntp true

echo "Ext4 formatting"
mkfs.ext4 /dev/sda1

echo "Mounting.."
mount /dev/sda1 /mount

echo "Installing base and base-devel"
pacstrap /mnt base base-devel

echo "Generating fs tab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Changing root"
arch-chroot /mnt

echo "Setting local time"
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime

echo "Syncing hwclock"
hwclock --systohc

echo "Localization"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Network configuration"
echo "arch-pc" > /etc/hostname
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       arch-pc.localdomain       arch-pc"

echo "Change root password:"
passwd

echo "Adding a user"
useradd --create-home -aG power,storage,wheel cezar
passwd cezar

echo "Setting sudo"
echo "%wheel ALL=(ALL) ALL"
