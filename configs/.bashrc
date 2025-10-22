# -----------------------------------------------------------------
# Recursively source all files from ~/.config/bash/
# -----------------------------------------------------------------
BASH_CONFIG_DIR="$HOME/.config/bash"

# Check if the custom config directory exists
if [ -d "$BASH_CONFIG_DIR" ]; then
  
  # Use 'find' to get all files recursively.
  # -type f ensures we only source files, not directories.
  #
  # We use process substitution (< <(...)) instead of a pipe (|)
  # to ensure the 'while' loop runs in the *current* shell.
  # This allows aliases and functions to be correctly sourced.
  while IFS= read -r -d '' file; do
    
    # Check if the file is readable before trying to source it
    if [ -r "$file" ]; then
      . "$file"
    fi
    
  done < <(find -L "$BASH_CONFIG_DIR" -type f -print0)
fi
# --- End of recursive source ---

