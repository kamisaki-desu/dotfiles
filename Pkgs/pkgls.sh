#!/bin/bash

pacman -Qqe > pacman-pkgs.txt
yay -Qm | awk '{print $1}' > aur-pkgs.txt
flatpak list --app | awk '{print $1}' > flatpak-pkgs.txt
echo "The package lists have been retrieved"
