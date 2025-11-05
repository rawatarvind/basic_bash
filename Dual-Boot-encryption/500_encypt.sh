#!/bin/bash
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




