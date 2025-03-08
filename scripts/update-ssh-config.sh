#!/bin/bash

# Get the current project name from the current directory
PROJECT_NAME=$(basename $(pwd))

# Find the VM name that starts with the project name
VM_NAME=$(limactl list | grep -E "^$PROJECT_NAME(\.|$)" | awk '{print $1}' | head -1)

# If no VM found, use just the project name
if [ -z "$VM_NAME" ]; then
    VM_NAME="$PROJECT_NAME"
fi

# Get the current port from lima
PORT=$(limactl list | grep "$VM_NAME" | awk '{print $3}' | sed 's/.*://')

if [ -z "$PORT" ]; then
    echo "Error: Could not find port for $VM_NAME VM"
    exit 1
fi

# Extract domain parts for host entries
if [[ "$VM_NAME" == *"."* ]]; then
    # If VM name has dots, use the full name for the domain
    DOMAIN_NAME="$VM_NAME"
else
    # If VM name has no dots, just use the project name
    DOMAIN_NAME="$PROJECT_NAME"
fi

# Remove any existing host keys for this host and IP
ssh-keygen -R "$PROJECT_NAME.test"
ssh-keygen -R "$DOMAIN_NAME.test"
ssh-keygen -R "127.0.0.1:$PORT"
ssh-keygen -R "192.168.64.3"
ssh-keygen -R "127.0.0.1"

# Remove the known_hosts file if it exists
rm -f ~/.ssh/known_hosts

# Create a temporary file for the new host entry
cat > ~/.ssh/config.tmp << EOF
Host $PROJECT_NAME.test
  HostName 127.0.0.1
  User $USER
  Port $PORT
  IdentityFile $HOME/.lima/_config/user
  IdentityFile $HOME/.ssh/id_ed25519
  StrictHostKeyChecking accept-new
  UserKnownHostsFile ~/.ssh/known_hosts

Host $DOMAIN_NAME.test
  HostName 127.0.0.1
  User $USER
  Port $PORT
  IdentityFile $HOME/.lima/_config/user
  IdentityFile $HOME/.ssh/id_ed25519
  StrictHostKeyChecking accept-new
  UserKnownHostsFile ~/.ssh/known_hosts
EOF

# Create a backup of the current config
cp ~/.ssh/config ~/.ssh/config.backup

# Create a new config file with only the new entry
cat ~/.ssh/config.tmp > ~/.ssh/config

# Clean up
rm ~/.ssh/config.tmp

# Update hosts file
sudo sed -i '' "/$PROJECT_NAME.test/d" /etc/hosts
sudo sed -i '' "/$DOMAIN_NAME.test/d" /etc/hosts
echo "192.168.64.3 $PROJECT_NAME.test www.$PROJECT_NAME.test" | sudo tee -a /etc/hosts
echo "192.168.64.3 $DOMAIN_NAME.test www.$DOMAIN_NAME.test" | sudo tee -a /etc/hosts

echo "Updated SSH config and hosts file for $PROJECT_NAME.test and $DOMAIN_NAME.test with port $PORT" 