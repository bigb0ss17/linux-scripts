#!/bin/sh
# Programmed by Vincent Pham

if [ $# -lt 1 ]; then
        echo "Usage: $0 <vm_name>"
        exit 1
fi

VM_NAME="$1"

if [ -f "$HOME/bin/vm.conf" ]; then
        . "$HOME/bin/vm.conf"
else
        echo "Error: $HOME/bin/vm.conf file cannnot be found! boohoo"
        exit 2
fi

HDD_NAME="$HOME/VirtualBox Vms/$VM_NAME/$VM_NAME.vdi"

# Check all required information
#echo "Vm name: $VM_NAME"
#echo "IDE name: $IDECTRL_NAME"
#echo "SATA name: $SATACTRL_NAME"
#echo "Disk size: $HDD_NAME"
#echo "Disk file name: $HDD_SIZE"
#echo "Memory size: $MEM_SIZE"
#echo "NIC name: $NIC_NAME"
#echo "VRDE port: $VRDE_PORT"


# Create vm
vboxmanage createvm --name "$VM_NAME" --register
RET_CODE="$?"
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot create a VM ($VM_NAME)."
        exit 3
fi

# create ide controll
vboxmanage storagectl "$VM_NAME" --name "$IDECTRL_NAME" --add ide
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot create a IDE controller ($IDECTRL_NAME)."
        removevm.sh "$VM_NAME"
        exit 4
fi

# create SATA controller
vboxmanage storagectl "$VM_NAME" --name "$SATACTRL_NAME" --add sata --controller intelahci
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot create a SATA controller ($SATACTRL_NAME)."
        removevm.sh "$VM_NAME"
        exit 5
fi

# Create HDD
vboxmanage createhd --filename "$HDD_NAME" --size "$HDD_SIZE"
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot create HDD ($HDD_NAME)."
        removevm.sh "$VM_NAME"
        exit 6
fi

# Attach the HDD
vboxmanage storageattach "$VM_NAME" --storagectl "$SATACTRL_NAME" --port 0 --device 0 --type hdd --medium "$HDD_NAME"
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot create a SATA controller ($HDD_NAME)."
        removevm.sh "$VM_NAME"
        exit 7
fi

# Modify the VM
vboxmanage modifyvm "$VM_NAME" --memory "$MEM_SIZE" --chipset ich9 --acpi on --boot1 dvd --nic1 bridged --bridge-adapter1 "$NIC_NAME" --vrdeport "$VRDE_PORT" --vrde on
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
        echo "Error($RET_CODE): cannot modify the VM ($VM_NAME)."
        removevm.sh "$VM_NAME"
        exit 8
fi


#The VM has been created
echo "Hallelujah, the VM ($VM_NAME) has been created successfully!"
