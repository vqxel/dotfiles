#!/usr/bin/env bash

# Get the workspace name of the currently active window using hyprctl and jq
active_ws=$(hyprctl activewindow -j | jq -r ".workspace.name")

# Check if the workspace name contains "special"
if [[ "$active_ws" == *"special"* ]]; then
    # If currently in a special workspace, move it to the current active REGULAR workspace (e+0)
    hyprctl dispatch movetoworkspace e+0
else
    # If currently in a regular workspace, move it to the special workspace
    hyprctl dispatch movetoworkspace special
fi
