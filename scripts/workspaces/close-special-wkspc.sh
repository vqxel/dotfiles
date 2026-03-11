#!/usr/bin/env bash
# Get the name of the active special workspace on the current monitor
active_special=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name')

# If it's not empty (meaning one is open), toggle it closed.
if [[ -n "$active_special" ]]; then
    # 'cut' is used to remove the "special:" prefix if necessary, 
    # though recent Hyprland versions often handle the full name.
    hyprctl dispatch togglespecialworkspace "$(echo "$active_special" | cut -d: -f2)"
fi
