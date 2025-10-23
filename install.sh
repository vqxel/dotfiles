#!/bin/bash
set -e

# --- Configuration ---
# Get the absolute path to the directory where this script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Set the source directory for your configs
SOURCE_DIR="$SCRIPT_DIR/configs"

# Set the destination directory (uses $XDG_CONFIG_HOME if set, otherwise defaults to $HOME/.config)
DEST_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- New: Make scripts executable ---
echo "---"
echo "Making scripts executable..."

APPS_DIR="$SCRIPT_DIR/apps"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
DIRS_TO_CHMOD=("$APPS_DIR" "$SCRIPTS_DIR")

for dir in "${DIRS_TO_CHMOD[@]}"; do
  if [ -d "$dir" ]; then
    echo "Processing $dir..."
    # Find all files in the directory and make them executable
    # Using -exec ... {} + is efficient and safe for filenames
    find "$dir" -type f -exec chmod +x {} +
  else
    echo "WARNING: $dir not found. Skipping."
  fi
done

# --- Main Script ---
echo "---"
echo "Starting config installation..."
echo "Source:      $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo "---"

# Ensure the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory $SOURCE_DIR not found."
  exit 1
fi

# Ensure the destination directory exists
echo "Ensuring destination $DEST_DIR exists..."
mkdir -p "$DEST_DIR"

# --- Handle .bashrc specially ---
CONFIG_BASHRC="$SOURCE_DIR/.bashrc"
SYSTEM_BASHRC="$HOME/.bashrc"

if [ -f "$CONFIG_BASHRC" ]; then
  echo "Found $CONFIG_BASHRC. Checking system's $SYSTEM_BASHRC..."
  
  # Ensure the system .bashrc exists before trying to append to it
  touch "$SYSTEM_BASHRC"
  
  # Create the source line we want to add
  SOURCE_LINE="source $CONFIG_BASHRC"
  
  # Check if the line already exists in the system .bashrc
  if grep -Fxq "$SOURCE_LINE" "$SYSTEM_BASHRC"; then
    echo "WARNING: $SYSTEM_BASHRC already sources $CONFIG_BASHRC. Skipping."
  else
    echo "Appending source command to $SYSTEM_BASHRC..."
    # Append the source line
    echo "" >> "$SYSTEM_BASHRC" # Add a newline for safety
    echo "# Load custom .bashrc from dotfiles" >> "$SYSTEM_BASHRC"
    echo "$SOURCE_LINE" >> "$SYSTEM_BASHRC"
    echo "Successfully updated $SYSTEM_BASHRC."
  fi
else
  echo "No .bashrc found in $SOURCE_DIR, skipping .bashrc setup."
fi

echo "---"
echo "Starting symlinking for other configs (directories and files)..."

# Find all files AND directories in $SOURCE_DIR and loop through them
# We use -maxdepth 1 so we only get the immediate children of 'configs'
# We also add -not -name .bashrc to exclude it from this loop
find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -not -name ".bashrc" | while read -r config_path; do
  
  # Get just the config name (e.g., "nvim", "alacritty", "hyprland.conf")
  config_name=$(basename "$config_path")
  
  # Define the full path for the new symlink
  dest_path="$DEST_DIR/$config_name"

  # --- Special handling for hyprland ---
  # If we find "hyprland.conf", we should link it to $DEST_DIR/hypr/hyprland.conf
  if [ "$config_name" == "hyprland.conf" ]; then
    echo "Found hyprland.conf, handling specially..."
    HYPR_DIR="$DEST_DIR/hypr"
    dest_path="$HYPR_DIR/hyprland.conf"
    
    if [ ! -d "$HYPR_DIR" ]; then
      echo "Creating $HYPR_DIR directory..."
      mkdir -p "$HYPR_DIR"
    fi
  fi
  
  # Check if a file, directory, or symlink already exists at the destination
  if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
    echo "WARNING: $dest_path already exists. Skipping."
  else
    echo "Linking $config_path -> $dest_path"
    # Create the symbolic link
    ln -s "$config_path" "$dest_path"
  fi
done

echo "---"
echo "Installation complete."

