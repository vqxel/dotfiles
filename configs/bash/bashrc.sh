# --- 1. General Aliases & Exports (All Systems) ---

# Set preferred editor
alias vim="nvim"
alias svim="sudoedit"

alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'

alias desktop='cd /usr/share/applications'
alias sdesktop='cd ~/.local/share/applications'

alias lhc='kitty +kitten ssh rbagheri@uceftrk01.ps.uci.edu'
alias lhcfs='sshfs rbagheri@uceftrk01.ps.uci.edu: ~/mntlhc'
alias ulhcfs='fusermount -u ~/mntlhc'

export SUDO_EDITOR="nvim"

export PATH="$HOME/.local/bin:$PATH"

# --- 2. Shell Prompt & Fetch (All Systems) ---
# These are run before system-specifics as they might set PROMPT_COMMAND

# Run fastfetch on shell start
if command -v fastfetch &> /dev/null; then
    fastfetch -c ~/.config/fastfetch/minimal.jsonc
fi

# Initialize Oh My Posh
if command -v oh-my-posh &> /dev/null; then

  if [ -n "$BASH_VERSION" ]; then
    # We are in Bash
    eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/custom.omp.json)"
  elif [ -n "$ZSH_VERSION" ]; then
    # We are in Zsh
    eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/custom.omp.json)"
  fi
  
fi

# --- 3. System-Specific Configuration ---

case "$(uname -s)" in
    #################
    #    L I N U X
    #################
    Linux)
        # Use eza (modern ls replacement)
        alias ls='eza -a --icons=always'
        alias ll='eza -al --icons=always'
        alias lt='eza -a --tree --level=1 --icons=always'

        # Systemd power control
        alias shutdown='systemctl poweroff'

        # Freedesktop application directories
        alias desktop='cd /usr/share/applications'
        alias sdesktop='cd ~/.local/share/applications'


        # --- Terminal CWD Tracking for Hyprland (Linux-Only) ---

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
                flock "$TERMINAL_CWD_DB.lock" bash -c '
                    jq --arg addr "$MY_HYPR_WINDOW_ADDR" --arg cwd "$PWD" \
                       ". + {(\$addr): \$cwd}" "$TERMINAL_CWD_DB" > "$TERMINAL_CWD_DB.tmp"
                    mv "$TERMINAL_CWD_DB.tmp" "$TERMINAL_CWD_DB"
                '
            }

            # Function to remove this terminal's entry on exit
            cleanup_cwd_db() {
                if [ -z "$MY_HYPR_WINDOW_ADDR" ]; then
                    return
                fi

                flock "$TERMINAL_CWD_DB.lock" bash -c '
                    jq --arg addr "$MY_HYPR_WINDOW_ADDR" "del(.[\$addr])" "$TERMINAL_CWD_DB" > "$TERMINAL_CWD_DB.tmp_del"
                    mv "$TERMINAL_CWD_DB.tmp_del" "$TERMINAL_CWD_DB"
                '

                rm -f "$TERMINAL_CWD_DB.lock"
            }

            # Set the prompt command to update CWD every time the prompt is shown
            # This prepends the function to the existing $PROMPT_COMMAND (set by oh-my-posh)
            export PROMPT_COMMAND="update_cwd_db; $PROMPT_COMMAND"

            # Set the exit trap to clean up the entry when the shell closes
            trap cleanup_cwd_db EXIT

        fi
        # --- End Terminal CWD Tracking ---
        ;;

    #################
    #   M A C O S
    #################
    Darwin)
        # Use standard ls with color enabled
        alias ls='ls -aG'    # -a = all files, -G = color
        alias ll='ls -alhgG' # -l = long, -h = human-readable, g = skip group
        alias lt='ls -alhgG' # Default 'ls' has no tree view, so alias to 'll'
        
        # 'shutdown', 'desktop', and 'sdesktop' aliases are not created
        ;;
esac

# --- Custom Keybind for Cmd+Enter (Zsh Only) ---

if [ -n "$ZSH_VERSION" ]; then
  # 1. Define the function (widget) you want to run.
  #    This example just runs the command (like pressing Enter)
  #    You could change "accept-line" to any other command.
  run-cmd-enter-widget() {
    zle accept-line  # This simulates pressing Enter
    print "YOU PRESSED"
    
    # Example: To clear the buffer and then run:
    # zle -I # (In-place) clear buffer
    # print "You pressed Cmd+Enter!"
    # zle accept-line
  }

  # 2. Create the new widget in the Zsh Line Editor (ZLE)
  zle -N run-cmd-enter-widget

  # 3. Bind your custom escape sequence to the new widget
  #    Note: \e is the same as ^[
  bindkey '\e[13;9u' run-cmd-enter-widget
fi
