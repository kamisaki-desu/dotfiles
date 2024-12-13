#!/bin/bash

# Arch Linux System Update Script with Snapper backup, Flatpak update, yay update

# Define commands as variables
PACMAN_UPDATE_CMD="sudo pacman -Syu"
PACMAN_REPO_UPDATE_CMD="sudo pacman -Syy"
UNUSED_PACKAGES_CMD="pacman -Qqdt"
YAY_UPDATE_CMD="yay -Syu --noconfirm"
AUR_UPDATE_CMD="yay -Sua"
SNAPPER_CREATE_CMD="sudo snapper create -d"
FLATPAK_UPDATE_CMD="flatpak update -y"
REBOOT_CMD="sudo reboot"

# Take a snapshot before the update using Snapper
echo "📸 Creating a pre-update snapshot with Snapper..."
echo "Command: $SNAPPER_CREATE_CMD \"backup: pre-system update\""
$SNAPPER_CREATE_CMD "backup: pre-system update" || echo "❌ Error creating pre-update snapshot. Skipping..."

# Update package repositories
echo "🔄 Updating package repositories..."
echo "Command: $PACMAN_REPO_UPDATE_CMD"
$PACMAN_REPO_UPDATE_CMD || echo "❌ Error updating repositories. Continuing..."

# Update the system packages
echo "⬆️ Updating the system packages..."
echo "Command: $PACMAN_UPDATE_CMD"
$PACMAN_UPDATE_CMD || echo "❌ Error updating system packages. Continuing..."

# Update yay itself
echo "🆙 Updating yay..."
echo "Command: $YAY_UPDATE_CMD"
$YAY_UPDATE_CMD || echo "❌ Error updating yay. Continuing..."

# Update AUR packages
echo "🔄 Updating AUR packages..."
echo "Command: $AUR_UPDATE_CMD"
$AUR_UPDATE_CMD || echo "❌ Error updating AUR packages. Continuing..."

# Update Flatpak packages
echo "📦 Updating Flatpak packages..."
echo "Command: $FLATPAK_UPDATE_CMD"
$FLATPAK_UPDATE_CMD || echo "❌ Error updating Flatpak packages. Continuing..."

# Clean up unused packages
echo "🧹 Removing unused packages..."
UNUSED_PACKAGES=$($UNUSED_PACKAGES_CMD)
if [[ -n "$UNUSED_PACKAGES" ]]; then
  PACMAN_REMOVE_UNUSED_CMD="sudo pacman -Rs $UNUSED_PACKAGES"
  echo "Command: $PACMAN_REMOVE_UNUSED_CMD"
  $PACMAN_REMOVE_UNUSED_CMD || echo "❌ Error removing unused packages. Skipping..."
else
  echo "No unused packages to remove."
fi

# Take a snapshot after the update using Snapper
echo "📸 Creating a post-update snapshot with Snapper..."
echo "Command: $SNAPPER_CREATE_CMD \"backup: post-system update\""
$SNAPPER_CREATE_CMD "backup: post-system update" || echo "❌ Error creating post-update snapshot. Skipping..."

# Ask if the user wants to reboot after the update
echo "🔄 If a new kernel was updated, you may want to reboot your system."
read -p "Do you want to reboot now? (y / n): " reboot_response

if [[ "$reboot_response" == "y" ]]; then
  echo "🔄 Rebooting the system..."
  echo "Command: $REBOOT_CMD"
  $REBOOT_CMD
else
  echo "✅ System will not be rebooted. The update process is complete."
fi
