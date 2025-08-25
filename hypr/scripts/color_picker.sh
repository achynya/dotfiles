#!/usr/bin/env bash

# Function to copy text to clipboard
copy_to_clipboard() {
    local content="$1"

    # Check if `wl-copy` is available (Wayland clipboard tool)
    if command -v wl-copy &> /dev/null; then
        echo "$content" | wl-copy
        echo "Color copied to clipboard: $content"
    else
        echo "Error: 'wl-copy' is not installed. Please install it to use the clipboard functionality."
        exit 1
    fi
}

# Main script logic
echo "Please select a pixel on the screen..."

# Use hyprpicker to pick a color
hex_color=$(hyprpicker)

# Check if a color was picked
if [[ -z "$hex_color" ]]; then
    echo "No color selected. Exiting..."
    exit 1
fi

# Display the picked color
echo "Picked color: $hex_color"

# Copy the picked color to the clipboard
copy_to_clipboard "$hex_color"
