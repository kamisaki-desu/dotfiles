#!/bin/bash

pid=$(hyprctl clients | grep -A4 "class: kitty-center" | grep "pid:" | awk '{print $2}')

if [ -z "$pid" ]; then
    kitty --class kitty-center &
else
    hyprctl dispatch closewindow "kitty-center"
fi
