#!/bin/bash 

#Chosing Partitions
echo "::Choosing partitons..."
read -p "Enter the main partition (eg. /dev/sda1): " main
read -p "Enter the swap partition (eg. /dev/sda2): " swap


#Formating partitions
echo "::Formatting Partitions..."
exec mkdfs.ext4 $main
exec mkswap $swap
exec swapon $swap

# Mount File System
exec mount $main /mnt

# Installing System:
echo "::Intalling the base system..."
exec pacstrap /mnt base base-devel xorg xorg-server git vim grub alsa-utils

echo "::Running genfstab..."
exec genfstab -U /mnt >> /mnt/etc/fstab

exec arch-chroot /mnt

# Setting time zone:
echo "::Setting Time Settings"
exec ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
exec hwclock --systohc

echo "::Uncomment wanted locales:"
#exec vim /etc/locale.gen
exec wget "https://raw.githubusercontent.com/HonoredTarget/ArchLinuxInstallScripts/master/supportFiles/locale.gen" -o locale.gen
exec mv locale.gen /etc/locale.gen
exec locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname:
read -p "Enter hostname: " name
exec echo $name > /etc/hostname

exec echo "127.0.0.1	localhost" > /etc/hosts
exec echo "::1		localhost" > /etc/hosts
exec echo "127.0.1.1	$name.localdomain	$name" > /etc/hosts

# running mkinitcpio
exec mkinitcpio -p linux

echo "::Setting Password"
exec passwd

#Grub
exec grub-mkconfig -o /boot/grub/grub.cfg
exec grub-install --target=i386-pc $main

#Username
read -p "Enter username: " username

exec useradd -m -g users -G wheel -s /bin/bash $username
exec passwd $username

exec wget "https://raw.githubusercontent.com/HonoredTarget/ArchLinuxInstallScripts/master/supportFiles/sudoers" -o sudoers
exec sudo mv sudoers /etc/sudoers

#wget "https://raw.githubusercontent.com/HonoredTarget/ArchLinuxInstallScripts/master/supportScritps/i3.sh"
