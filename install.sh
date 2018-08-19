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

cp packages.txt /mnt
cp post-install.sh /mnt
arch-chroot /mnt post-install.sh
