#!/bin/bash

# Get the project name from the current directory
PROJECT_NAME=$(basename $(pwd))

# Find the VM name that starts with the project name
VM_NAME=$(limactl list | grep -E "^$PROJECT_NAME(\.|$)" | awk '{print $1}' | head -1)

# If no VM found, use just the project name
if [ -z "$VM_NAME" ]; then
    VM_NAME="$PROJECT_NAME"
fi

# Start the VM
echo "Starting VM: $VM_NAME"
trellis vm start

# Update SSH config
./trellis/scripts/update-ssh-config.sh 