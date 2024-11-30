#!/bin/bash

echo "Starting the script to install Yay, enable multilib, and enable Chaotic AUR..."

echo "Installing yay..."
./helpers/install-yay.sh
if [ $? -ne 0 ]; then
    echo "Error: Failed to run install-yay.sh. Exiting."
    exit 1
fi

echo "Enabling multilib..."
./helpers/enable-multilib.sh
if [ $? -ne 0 ]; then
    echo "Error: Failed to run enable-multilib.sh. Exiting."
    exit 1
fi

echo "Enabling ChaoticAUR..."
sudo sh ./helpers/enable-chaotic-aur.sh
if [ $? -ne 0 ]; then
    echo "Error: Failed to run enable-chaotic-aur.sh. Exiting."
    exit 1
fi

echo "Successfully!"
