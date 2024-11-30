#!/bin/bash

# Check if yay is already installed
if pacman -Qi yay &>/dev/null; then
  echo "yay is already installed."
else
  echo "Installing yay..."
  # Move to the ~/.cache directory and install yay
  cd ~/.cache || exit
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git --depth 1
  cd yay || exit
  makepkg -si --noconfirm

  # Clean up the yay directory if desired
  echo "Cleaning up yay build directory..."
  cd ~
  sudo rm -rf ~/.cache/yay
fi
