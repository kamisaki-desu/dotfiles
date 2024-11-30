#!/bin/bash

echo "Starting Chaotic AUR installation..."

# Receive the GPG key
echo "Receiving GPG key for Chaotic AUR..."
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
if [ $? -ne 0 ]; then
    echo "Error: Failed to receive the GPG key."
    exit 1
fi

# Sign the GPG key
echo "Signing the GPG key..."
sudo pacman-key --lsign-key 3056513887B78AEB
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the GPG key."
    exit 1
fi

# Install Chaotic AUR keyring package
echo "Installing Chaotic AUR keyring..."
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Chaotic keyring."
    exit 1
fi

# Install Chaotic AUR mirrorlist
echo "Installing Chaotic AUR mirrorlist..."
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Chaotic mirrorlist."
    exit 1
fi

# Add Chaotic AUR repository to pacman.conf
echo "Adding Chaotic AUR repository to /etc/pacman.conf..."

# Ensure pacman.conf exists and is writable
if [ ! -w "/etc/pacman.conf" ]; then
    echo "Error: /etc/pacman.conf is not writable. Please run the script as root."
    exit 1
fi

# Add Chaotic AUR repository at the end of pacman.conf
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | tee -a /etc/pacman.conf > /dev/null

if [ $? -eq 0 ]; then
    echo "Chaotic AUR repository added successfully to /etc/pacman.conf."
else
    echo "Error: Failed to update /etc/pacman.conf."
    exit 1
fi

# Update package databases
echo "Updating package databases..."
pacman -Sy
if [ $? -eq 0 ]; then
    echo "Chaotic AUR installation complete!"
else
    echo "Error: Failed to update package databases."
    exit 1
fi
