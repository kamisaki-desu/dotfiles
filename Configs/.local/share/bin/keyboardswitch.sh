#!/usr/bin/env sh

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh

hyprctl switchxkblayout all next

sleep 0.2

layMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')
swayosd-client --custom-message=${layMain} --custom-icon="input-keyboard"
