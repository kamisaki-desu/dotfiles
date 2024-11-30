#!/bin/bash

PACMAN_FILE="../Pkgs/pacman-pkgs.txt"
AUR_FILE="../Pkgs/aur-pkgs.txt"
FLATPAK_FILE="../Pkgs/flatpak-pkgs.txt"

# Function to install Pacman packages
install_pacman_packages() {
    echo "Installing Pacman packages..."
    if [[ -f $PACMAN_FILE ]]; then
        sudo pacman -S --needed - < "$PACMAN_FILE"
    else
        echo "Error: $PACMAN_FILE not found!"
    fi
}

# Function to install AUR packages
install_aur_packages() {
    echo "Installing AUR packages..."
    if [[ -f $AUR_FILE ]]; then
        yay -S --needed - < "$AUR_FILE"
    else
        echo "Error: $AUR_FILE not found!"
    fi
}

# Function to install Flatpak packages
install_flatpak_packages() {
    echo "Installing Flatpak packages..."
    if [[ -f $FLATPAK_FILE ]]; then
        while IFS= read -r package; do
            flatpak install -y "$package"
        done < "$FLATPAK_FILE"
    else
        echo "Error: $FLATPAK_FILE not found!"
    fi
}

# Main menu
echo "Please select an option:"
echo "1. Install Pacman packages"
echo "2. Install AUR packages"
echo "3. Install Flatpak packages"
echo "4. Install all packages"

read -rp "Enter your choice (1-4): " choice

case $choice in
    1)
        install_pacman_packages
        ;;
    2)
        install_aur_packages
        ;;
    3)
        install_flatpak_packages
        ;;
    4)
        echo "Starting with Pacman packages..."
        install_pacman_packages
        echo "Now installing AUR packages..."
        install_aur_packages
        echo "Finally, installing Flatpak packages..."
        install_flatpak_packages
	echo "Finished!"
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

