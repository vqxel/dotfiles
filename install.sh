#!/bin/bash

# NOTICE: This install script was made with the help of Gemini

set -e

# --- Configuration ---
# Get the absolute path to the directory where this script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Set the source directory for your configs
SOURCE_DIR="$SCRIPT_DIR/configs"

# Set the destination directory (uses $XDG_CONFIG_HOME if set, otherwise defaults to $HOME/.config)
DEST_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- Main Script ---
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
echo "Starting symlinking for other configs..."

# Find all directories in $SOURCE_DIR and loop through them
# We use -maxdepth 1 so we only get the immediate children of 'configs'
# We also add -not -name .bashrc to exclude it from this loop
find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -type d -not -name ".bashrc" | while read -r dir_path; do
  
  # Get just the directory name (e.g., "nvim", "alacritty")
  config_name=$(basename "$dir_path")
  
  # Define the full path for the new symlink
  dest_path="$DEST_DIR/$config_name"
  
  # Check if a file, directory, or symlink already exists at the destination
  if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
    echo "WARNING: $dest_path already exists. Skipping."
  else
    echo "Linking $config_name -> $dest_path"
    # Create the symbolic link
    ln -s "$dir_path" "$dest_path"
  fi
done

echo "---"
echo "Installation complete."

