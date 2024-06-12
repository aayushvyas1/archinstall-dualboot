#!/bin/bash

# Step 1: Connect to Wi-Fi using iwctl
echo "Connecting to Wi-Fi..."
iwctl device list
read -p "Enter your device name (e.g., wlan0): " device_name
iwctl station $device_name scan
iwctl station $device_name get-networks
read -p "Enter the network name you want to connect to: " network_name
iwctl station $device_name connect $network_name
iwctl exit
echo "Testing internet connection..."
ping -c 4 google.com
if [ $? -eq 0 ]; then
  echo "Internet connection is working."
else
  echo "Internet connection failed. Exiting."
  exit 1
fi

# Step 2: Update keyring and install archinstall
echo "Updating keyring and installing archinstall..."
pacman -Sy archlinux-keyring archinstall --noconfirm

# Step 3: Set font
echo "Setting console font..."
setfont ter-v22b

# Step 4: Enable parallel downloads in pacman
echo "Enabling parallel downloads..."
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Step 5: Enable fast mirrors with reflector
echo "Enabling fast mirrors..."
pacman -S reflector --noconfirm
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
read -p "Enter your country code for reflector (e.g., US): " country_code
reflector -a 48 -c $country_code -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# Step 6: Create partitions using cfdisk
echo "Starting cfdisk for partitioning..."
cfdisk
echo "Partitions created. Listing partitions..."
lsblk

# Step 7: Format partitions
echo "Formatting partitions..."
read -p "Enter the EFI partition (e.g., /dev/nvme0n1p1): " efi_partition
mkfs.fat -F32 $efi_partition

read -p "Enter the root partition (e.g., /dev/nvme0n1p2): " root_partition
mkfs.ext4 $root_partition

read -p "Enter the swap partition (e.g., /dev/nvme0n1p3): " swap_partition
mkswap $swap_partition

# Step 8: Mount partitions
echo "Mounting partitions..."
mount $root_partition /mnt
mkdir /mnt/boot
mount $efi_partition /mnt/boot
swapon $swap_partition

# Step 9: Done, ready to run archinstall

echo "System is ready. You can now run the archinstall script."
