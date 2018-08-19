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
echo "127.0.1.1       arch-pc.localdomain       arch-pc" >> /etc/hosts

echo "Change root password:"
passwd

echo "Adding a user"
useradd --create-home -aG power,storage,wheel cezar
passwd cezar

echo "Setting sudo"
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo "Installing packages"
pacman -Syy
pacman -S - < packages.txt
