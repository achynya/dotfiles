#!/usr/bin/env bash

# Get the current workspace
CURRENT_WORKSPACE=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Get the target workspace from the argument
TARGET_WORKSPACE=$1

# Check if the current workspace matches the target workspace
if [[ "$CURRENT_WORKSPACE" -eq "$TARGET_WORKSPACE" ]]; then
    # Switch to the last active workspace
    hyprctl dispatch workspace prev
else
    # Switch to the target workspace
    hyprctl dispatch workspace $TARGET_WORKSPACE
fi
