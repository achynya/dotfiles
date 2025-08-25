#!/bin/bash

# Define step size (in pixels)
STEP=10

# Parse arguments for direction
DIRECTION=$1

# Function to resize the window
resize_window() {
    case "$DIRECTION" in
        left)  hyprctl dispatch resizeactive -"$STEP" 0 ;;
        right) hyprctl dispatch resizeactive "$STEP" 0 ;;
        up)    hyprctl dispatch resizeactive 0 -"$STEP" ;;
        down)  hyprctl dispatch resizeactive 0 "$STEP" ;;
    esac
}

# Continuously resize the window while the key is held
while true; do
    resize_window
    sleep 0.05 # Adjust the delay for smoother or faster resizing
done
