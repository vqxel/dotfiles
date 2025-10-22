fastfetch -c ~/.config/fastfetch/minimal.jsonc

alias vim="nvim"

alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'

eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/custom.omp.json)"

# --- Terminal CWD Tracking for Hyprland ---

# Only run this if we're in Kitty and Hyprland
if [ "$TERM" = "xterm-kitty" ] && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then

    export TERMINAL_CWD_DB=~/.cache/terminal_cwd.json

    # Get this window's unique address from hyprctl.
    # We strip "0x" to use it as a clean JSON key.
    export MY_HYPR_WINDOW_ADDR=$(hyprctl activewindow -j | jq -r '.address' | sed 's/0x//')

    # Ensure the database file exists and is valid JSON
    if [ ! -f "$TERMINAL_CWD_DB" ] || ! jq -e . "$TERMINAL_CWD_DB" >/dev/null 2>&1; then
        echo "{}" > "$TERMINAL_CWD_DB"
    fi

    # Function to update CWD in the database
    update_cwd_db() {
        if [ -z "$MY_HYPR_WINDOW_ADDR" ]; then
            return
        fi

        # Use flock for safe concurrent writes from multiple terminals
        (
            flock 200
            jq --arg addr "$MY_HYPR_WINDOW_ADDR" --arg cwd "$PWD" \
               '. + {($addr): $cwd}' "$TERMINAL_CWD_DB" > "$TERMINAL_CWD_DB.tmp"
            mv "$TERMINAL_CWD_DB.tmp" "$TERMINAL_CWD_DB"
        ) 200>"$TERMINAL_CWD_DB.lock"
    }

    # Function to remove this terminal's entry on exit
    cleanup_cwd_db() {
        if [ -z "$MY_HYPR_WINDOW_ADDR" ]; then
            return
        fi

        (
            flock 200
            #hyprctl notify -1 5000 "rgb(ff1ea3)" "CLOSED $MY_HYPR_WINDOW_ADDR"
            jq "del(.\"$MY_HYPR_WINDOW_ADDR\")" "$TERMINAL_CWD_DB" > "$TERMINAL_CWD_DB.tmp_del"
            mv "$TERMINAL_CWD_DB.tmp_del" "$TERMINAL_CWD_DB"
        ) 200>"$TERMINAL_CWD_DB.lock"

        rm -f "$TERMINAL_CWD_DB.lock"
    }

    # Set the prompt command to update CWD every time the prompt is shown
    export PROMPT_COMMAND="update_cwd_db; $PROMPT_COMMAND"

    # Set the exit trap to clean up the entry when the shell closes
    trap cleanup_cwd_db EXIT

fi
# --- End Terminal CWD Tracking ---
