# Trellis VM Start

A collection of Ansible roles and scripts to enhance Trellis VM management.

## Overview

This project provides tools to improve the Trellis VM experience, particularly focusing on SSH configuration and VM startup.

## Installation

To install these tools into your Trellis project, use the installation script:

```bash
./scripts/install-trellis-vm-start.sh /path/to/your/trellis
```

For example:
```bash
./scripts/install-trellis-vm-start.sh /Users/username/Sites/your-project/trellis
```

## Components

- **SSH Configuration**: Automatically configures SSH for easy access to your Trellis VMs
- **VM Start Hooks**: Deploy hooks that run after VM startup
- **Utility Scripts**: Scripts for managing VM startup and SSH configuration

## Usage

After installation, you can use the VM Start functionality by running:

```bash
cd /path/to/your/trellis
ansible-playbook vm.yml
```

For more detailed information, see the README in the `scripts` directory. 