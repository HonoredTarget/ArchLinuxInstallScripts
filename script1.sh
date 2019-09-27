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