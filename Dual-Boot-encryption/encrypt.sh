#!/bin/bash

# this script is used to encrypt the Block devices on system. IN my case this there are two disks, each is 500GB.

set -euo pipefail

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Root check
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run this script as root!${RESET}"
    exit 1
fi

# Usage
if [ $# -lt 2 ]; then
    echo -e "${YELLOW}Usage: $0 <boot_device> <root_device>${RESET}"
    echo "Example: $0 /dev/sda1 /dev/sda2"
    exit 1
fi

luks_boot="$1"
root_dev="$2"
vg_name="vgubuntu"

# Validate devices
for dev in "$luks_boot" "$root_dev"; do
    if [ ! -b "$dev" ]; then
        echo -e "${RED}Error: Device $dev does not exist!${RESET}"
        exit 1
    fi
done

# Confirm destructive action
echo -e "${RED}WARNING: This will erase ALL data on $luks_boot and $root_dev!${RESET}"
read -rp "Type YES to continue: " confirm
if [ "$confirm" != "YES" ]; then
    echo "Aborted."
    exit 1
fi

echo -e "${GREEN}Encrypting boot partition: $luks_boot${RESET}"
cryptsetup luksFormat "$luks_boot"

echo -e "${GREEN}Encrypting root partition: $root_dev${RESET}"
cryptsetup luksFormat "$root_dev"

echo -e "${GREEN}Opening root encrypted device...${RESET}"
cryptsetup luksOpen "$root_dev" ubuntu

echo -e "${GREEN}Creating LVM physical volume...${RESET}"
pvcreate /dev/mapper/ubuntu

echo -e "${GREEN}Creating volume group $vg_name...${RESET}"
vgcreate "$vg_name" /dev/mapper/ubuntu

echo -e "${GREEN}Creating logical volumes...${RESET}"
lvcreate -n swap     -L 8G   "$vg_name"
lvcreate -n home     -L 200G "$vg_name"
lvcreate -n root     -L 50G  "$vg_name"
lvcreate -n tmp      -L 5G   "$vg_name"
lvcreate -n var_log  -L 5G   "$vg_name"
lvcreate -n var      -L 25G  "$vg_name"
lvcreate -n mnt_Data -L 160G "$vg_name"

echo -e "${GREEN}LVM setup complete! Current logical volumes:${RESET}"
lvs

# create encyption on disk 2 

echo -e "${GREEN} Enter the Disk2 device (e.g., /dev/sdb) ${RESET}"
read -r Disk2
if [ ! -b "$Disk2" ]; then
    echo -e "${RED}Error: Device $Disk2 does not exist!${RESET}"
    exit 1
fi

echo -e "${RED}WARNING: This will erase ALL data on $Disk2!${RESET}"
read -rp "Type YES to continue: " confirm2
if [ "$confirm2" != "YES" ]; then
    echo "Aborted."
    exit 1
fi

# Safer cryptsetup & LVM:

cryptsetup luksFormat "$Disk2"
cryptsetup luksOpen "$Disk2" ubuntu_mnt

pvcreate /dev/mapper/ubuntu_mnt
vgcreate vg1 /dev/mapper/ubuntu_mnt

lvcreate -n mnt_Data1 -L 200G vg1
lvcreate -n mnt_Data2 -L 200G vg1






