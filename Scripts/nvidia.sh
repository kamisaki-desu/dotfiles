#!/bin/bash

# Warning message
echo -e "\033[31mWARNING: This script could potentially cause issues with your system. Are you sure you want to continue? Press Enter to proceed or Ctrl+C to cancel.\033[0m"

# Wait for the user to press Enter
read -r

# Step 1: Update the system and install dependencies
echo "Updating system and installing dependencies..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm dkms linux-headers nvidia-dkms lib32-nvidia-utils nvidia-settings nvidia-utils

# Step 2: Verify installation
echo "Verifying NVIDIA DKMS installation..."
if pacman -Qs nvidia-dkms; then
    echo "NVIDIA DKMS drivers installed successfully!"
else
    echo "Error: Failed to install NVIDIA DKMS drivers."
    exit 1
fi

# Step 3: Rebuild DKMS modules
echo "Rebuilding DKMS modules..."
sudo dkms autoinstall

# Step 4: Restart the system
echo "NVIDIA DKMS installation is complete. A system reboot is required."
echo "Please restart your system to apply changes."

