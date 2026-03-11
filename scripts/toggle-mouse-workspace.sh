#!/bin/bash

LOCK_FILE=~/.cache/mouse_workspace_bindings.lock

# Check if bindings are currently disabled (lockfile exists)
if [ -f "$LOCK_FILE" ]; then
    # Enable the bindings
    hyprctl keyword bind , mouse:276, workspace, r+1
    hyprctl keyword bind , mouse:275, workspace, r-1

    # Remove lockfile to indicate bindings are enabled
    rm "$LOCK_FILE"

    echo "Mouse workspace bindings enabled"
else
    # Disable the bindings
    hyprctl keyword unbind , mouse:276
    hyprctl keyword unbind , mouse:275

    # Create lockfile to indicate bindings are disabled
    touch "$LOCK_FILE"

    echo "Mouse workspace bindings disabled"
fi

exit 0
