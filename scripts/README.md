# Trellis VM Start Installation Script

This directory contains scripts for installing and using the Trellis VM Start functionality.

## Installation

To install the Trellis VM Start files into your Trellis project, use the `install-trellis-vm-start.sh` script:

```bash
./install-trellis-vm-start.sh /path/to/your/trellis
```

For example:
```bash
./install-trellis-vm-start.sh /Users/username/Sites/your-project/trellis
```

This will copy all necessary files to your Trellis project, including:
- `deploy-hooks/vm-start-after.yml`
- `roles/ssh-config/tasks/main.yml`
- `roles/ssh-config/templates/ssh_config.j2`
- `vm.yml`

## Usage

After installation, you can use the VM Start functionality by running:

```bash
cd /path/to/your/trellis
ansible-playbook vm.yml
```

This will set up SSH configuration for your VM.

## Other Scripts

- `vm-start.sh`: Script to start the VM and configure SSH
- `update-ssh-config.sh`: Script to update SSH configuration 