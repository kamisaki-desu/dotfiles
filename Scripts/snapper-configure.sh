#!/bin/bash

# Script Title: Snapper and BTRFS Setup
# Description: This script will handle the installation of snapper, btrfs configurations, 
#              and the creation of the first root snapshot on a BTRFS filesystem.

echo -e "\033[31mWARNING: This script could potentially cause issues with your system. Are you sure you want to continue? Press Enter to proceed or Ctrl+C to cancel.\033[0m"

# Step 1: Install necessary packages (snapper, btrfs, and others)
echo "Step 1: Installing required packages..."
yay -S --noconfirm snapper snapper-rollback snap-pac snap-pac-grub grub-btrfs

# Step 2: Configure Snapper for BTRFS
echo "Step 2: Configuring Snapper for BTRFS..."
root_partition=$(findmnt / -o SOURCE -n | awk -F'[' '{print $1}')

sudo mount $root_partition /mnt
sudo btrfs su cr /mnt/@
sudo btrfs su cr /mnt/@home
sudo btrfs su cr /mnt/@cache
sudo btrfs su cr /mnt/@log
sudo btrfs su cr /mnt/@swap
sudo btrfs su cr /mnt/@snapshots

if mount | grep -q '/.snapshots'; then
    sudo umount /.snapshots
fi

sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mkdir /btrfs

root_uuid=$(sudo blkid $root_partition | grep -o 'UUID="[^"]*"' | head -n 1 | sed 's/UUID="//;s/"//')

cp /etc/fstab /etc/fstab.bak
sudo sed -i "s/^UUID=$root_uuid/#&/" /etc/fstab

cat <<EOF >> /etc/fstab
UUID=$root_partition /               btrfs     subvol=/@,noatime,compress=zstd 0 0
UUID=$root_partition /home           btrfs     subvol=/@home,noatime,compress=zstd 0 0
UUID=$root_partition /var/cache      btrfs     subvol=/@cache,noatime,compress=zstd 0 0
UUID=$root_partition /var/log        btrfs     subvol=/@log,noatime,compress=zstd 0 0
UUID=$root_partition /swap           btrfs     subvol=/@swap,noatime 0 0
UUID=$root_partition /.snapshots     btrfs     subvol=/@snapshots 0 0
UUID=$root_partition /btrfs          btrfs     rw,noatime,compress-force=zstd:5,ssd,space_cache,subvolid=5 0 0
EOF

sudo mount -a

# Step 3: Create the first root snapshot
echo "Step 3: Taking the first root snapshot..."
sudo snapper -c root create --description="first snapshot"
