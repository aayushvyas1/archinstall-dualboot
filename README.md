# archinstall-dualboot

This is guide for using archinstall script preloaded in iso, preparing the mount points and prerequisits for a error less sucessfull install of the new system. I'll make a script for automated install later.  

1, iwctl :-

    device list
    
    station [device name] scan
    
    station [device name] get-networks
    
  Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`, and then Press `Ctrl` and `C` to stop.
   ` Exit`

2, `pacman -S archlinux-keyring archinstall`

3, Set Font - `setfont ter-v22b`

4, Enable Parallel downloads - `sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf`

5, Enable fast mirrors -`pacman -S reflector `

    `cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup`
    
    `reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist`
    

6, Create partitions from `cfdisk` - 1GB boot, and rest Ext4, swap is automatic by the script

7, `lsblk` for listing partitions

8, Format Partitions - 
    
  Format the Arch EFI Partition (e.g., NVME0N1p5)
    `mkfs.fat -F32 /dev/nvme0n1p5`
    
  Format the root partition (e.g., NVME0N1p6)
    `mkfs.ext4 /dev/NVME0N1p6`
   
  Format the swap partition (e.g., nvme0n1p7)
    `mkswap /dev/nvme0n1p7`

9, Mount 
    `mount /dev/nvme0n1p6 /mnt`
    
    `mkdir /mnt/boot`
    
    `mount /dev/nvme0n1p5 /mnt/boot`
    
    `swapon /dev/nvme0n1p7`

10, Done now just run the `archinstall` script 
