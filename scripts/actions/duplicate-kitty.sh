#!/bin/bash

DB_FILE=~/.cache/terminal_cwd.json

# 1. Get the active window's class and address using hyprctl's JSON output
ACTIVE_WINDOW_DATA=$(hyprctl activewindow -j)
ACTIVE_CLASS=$(echo "$ACTIVE_WINDOW_DATA" | jq -r '.class')

# 2. If focused window is not 'kitty', just open a new kitty window
if [ "$ACTIVE_CLASS" != "kitty" ]; then
    kitty &
    exit 0
fi

# 3. Get the active window's unique address
ACTIVE_ADDR=$(echo "$ACTIVE_WINDOW_DATA" | jq -r '.address')

# 4. Look up the CWD in the database using the address as the key
# We strip "0x" from the key for jq compatibility
CWD=$(jq -r ".\"${ACTIVE_ADDR#*x}\"" "$DB_FILE")


#hyprctl notify -1 5000 "rgb(ff1ea3)" "$ACTIVE_ADDR @ $CWD"

# 5. Launch kitty
if [ -z "$CWD" ] || [ "$CWD" == "null" ]; then
    # Fallback: if CWD not found (e.g., shell hasn't run a command yet), open new window
    kitty &
else
    # Success: open in the recorded directory
    kitty --directory "$CWD" &
fi

exit 0
