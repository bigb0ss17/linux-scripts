# Linux VM Scripts

This repository contains Bash scripts I created to manage VirtualBox virtual machines on Linux. 

## Scripts

### 1. createvm.sh
- Automates the creation of a VirtualBox VM
- Configures IDE and SATA controllers, creates and attaches a virtual HDD
- Sets memory, chipset, network adapter, and VRDE port
- Usage: `./createvm.sh <vm_name>`

### 2. startvm.sh
- Starts a VM in headless mode
- Usage: `./startvm.sh <vm_name>`

### 3. lsrvms.sh
- Lists all currently running VMs
- Usage: `./lsrvms.sh`
