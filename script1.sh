#!/bin/bash 

# Checking for internet connection
echo "::Checking internet connection..."
if ping archlinux.org -c 1 > /dev/null; then
	echo "\tInternet Connection Affirmed"
else
	echo "Connection to Intenet Failed. Exiting..."
	exit; 
fi

# Update system clock
echo "::Updating system clock..."
timedatectl set-ntp true
echo "verifying clock..."
if timedatectl status; then
	echo "clock time verified."
else
	echo "failed"
fi

#Chosing Partitions
echo "::Choosing partitons..."
read -p "Enter the main disk: " disk

echo "::Make changes..."
exec cfdisk $disk

#Formating partitions
echo "::Formatting Partitions..."
exec mkdfs.ext4 $main
exec mkswap $swap
exec swapon $swap

# Mount File System
#exec mount $main /mnt

# Installing System:
#echo "::Intalling the base system..."
#exec pacstrap /mnt base base-devl xorg xorg-server git vim grub alsa-utils

#echo "::Running genfstab..."
#exec genfstab -U /mnt >> /mnt/etc/fstab

#arch-chroot /mnt

# Setting time zone:
#echo "::Setting Time Settings"
#exec ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
#exec hwclock --systohc

#echo "::Uncomment wanted locales:"
#exec vim /etc/locale.gen
#exec locale-gen
#echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname:
#read -p "Enter hostname: " name
#exec echo $name > /etc/hostname

#exec echo "127.0.0.1	localhost" > /etc/hosts
#exec echo "::1		localhost" > /etc/hosts
#exec echo "127.0.1.1	$name.localdomain	$name" > /etc/hosts

# running mkinitcpio
#exec mkinitcpio -p linux

#echo "::Settecho ing Password"
#exec passwd

#Grub
#exec grub-mkconfig -o /boot/grub/grub.cfg
#exec grub-install --target=i386-pc $main
#
#Username
#read -p "Enter username: " username

#exec useradd -m -g users -G wheel -s /bin/bash $username
exec passwd $username

#echo "Uncomment wheel group"
#exec sudo vim /etc/sudoers

#wget "https://raw.githubusercontent.com/HonoredTarget/ArchLinuxInstallScripts/master/supportScritps/i3.sh"
