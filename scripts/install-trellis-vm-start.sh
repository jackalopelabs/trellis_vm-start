#!/bin/bash

# Script to install Trellis VM Start files into a target Trellis project
# Usage: ./install-trellis-vm-start.sh /path/to/target/trellis

set -e

# Get the source directory (where this script and the files to copy are located)
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if target directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/target/trellis"
    exit 1
fi

TARGET_DIR="$1"

# Check if target directory exists and is a Trellis directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

if [ ! -f "$TARGET_DIR/ansible.cfg" ] && [ ! -d "$TARGET_DIR/group_vars" ]; then
    echo "Warning: Target directory does not appear to be a Trellis directory."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Installing Trellis VM Start files to: $TARGET_DIR"

# Create directories if they don't exist
mkdir -p "$TARGET_DIR/deploy-hooks"
mkdir -p "$TARGET_DIR/roles/ssh-config/tasks"
mkdir -p "$TARGET_DIR/roles/ssh-config/templates"

# Copy deploy-hooks files
echo "Copying deploy-hooks files..."
cp "$SOURCE_DIR/deploy-hooks/vm-start-after.yml" "$TARGET_DIR/deploy-hooks/"

# Copy roles files
echo "Copying roles files..."
cp "$SOURCE_DIR/roles/ssh-config/tasks/main.yml" "$TARGET_DIR/roles/ssh-config/tasks/"
cp "$SOURCE_DIR/roles/ssh-config/templates/ssh_config.j2" "$TARGET_DIR/roles/ssh-config/templates/"

# Copy vm.yml
echo "Copying vm.yml..."
cp "$SOURCE_DIR/vm.yml" "$TARGET_DIR/"

echo "Installation complete!"
echo "To use these files, run: cd $TARGET_DIR && ansible-playbook vm.yml" 