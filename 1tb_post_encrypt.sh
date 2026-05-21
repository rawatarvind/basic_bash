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
Disk2="$3"
vg_name="vgubuntu"


# Mount target system
if ! mountpoint -q /target; then
    mount "/dev/mapper/${vg_name}-root" /target
else
    echo -e "${YELLOW}/target is already mounted, skipping...${RESET}"
fi

if ! mountpoint -q /target/boot; then
    mount "$luks_boot" /target/boot
else
    echo -e "${YELLOW}/target/boot is already mounted, skipping...${RESET}"
fi

for n in proc sys dev; do
    if ! mountpoint -q "/target/$n"; then
        mount --rbind "/$n" "/target/$n"
    fi
done

# --- Ensure all fstab mounts are active inside chroot ---
chroot /target /bin/bash -c "mount -a"



# --- Root Device UUID ---
UUID=$(blkid -s UUID -o value "$root_dev")

if [ -n "$UUID" ]; then
    if chroot /target grep -q "$UUID" /etc/crypttab; then
        echo -e "${YELLOW}Entry for UUID=$UUID already exists in /etc/crypttab. Skipping...${RESET}"
    else
        chroot /target /bin/bash -c "echo 'ubuntu UUID=$UUID none luks,discard' >> /etc/crypttab"
        echo -e "${GREEN}Added entry for $root_dev (UUID=$UUID) to /etc/crypttab${RESET}"
    fi
else
    echo -e "${RED}Failed to find UUID for $root_dev${RESET}"
fi

# --- Disk2 UUID ---
UUID2=$(blkid -s UUID -o value "$Disk2")

if [ -n "$UUID2" ]; then
    if chroot /target grep -q "$UUID2" /etc/crypttab; then
        echo -e "${YELLOW}Entry for UUID=$UUID2 already exists in /etc/crypttab. Skipping...${RESET}"
    else
        chroot /target /bin/bash -c "echo 'ubuntu_mnt UUID=$UUID2 none luks,discard' >> /etc/crypttab"
        echo -e "${GREEN}Added entry for $Disk2 (UUID=$UUID2) to /etc/crypttab${RESET}"
    fi
else
    echo -e "${RED}Failed to find UUID for $Disk2${RESET}"
fi

# --- Update initramfs only once at the end ---
chroot /target /bin/bash -c "update-initramfs -k all -u"
echo -e "${GREEN}Initramfs updated successfully.${RESET}"



