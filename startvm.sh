#!/bin/sh
# Programmed by Vincent Pham

if [ $# -lt 1]; then
        echo "Usage: $0 <vm_name>"
        exit 1
fi

VM_NAME="$1"

vboxmanage startvm "$VM_NAME" --type headless