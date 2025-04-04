# Run this script while use live boot os in Ubuntu. 
# First decrept all partition in ubuntu 22

cryptsetup luksOpen /dev/

#make sure script runs as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo." 
    exit 1
fi

# Reduce the size of root partition
lvresize --resizefs --size 50G /dev/mapper/vgubuntu-root

# Set variable for volume group
VGS="vgubuntu"

# Create LVM partitions
lvcreate -L 200G -n home "$VGS"
lvcreate -L 25G -n var "$VGS"
lvcreate -L 5G -n tmp "$VGS"
lvcreate -L 5G -n var_log "$VGS"

# Ensure /var/log directory exists
mkdir -p /var/log

# Format new partitions with ext4 filesystem
for partition in home var tmp var_log; do
    mkfs.ext4 "/dev/mapper/${VGS}-$partition"
done

# Mount root partition to temporary location
mount /dev/mapper/vgubuntu-root /media

# Mount new partitions
mount /dev/mapper/vgubuntu-home /home
mount /dev/mapper/vgubuntu-var /var
mount /dev/mapper/vgubuntu-tmp /tmp
mount /dev/mapper/vgubuntu-var_log /var/log

# Use rsync to move data efficiently
rsync -avx /media/var/ /var/
rsync -avx /media/home/ /home/
rsync -avx /media/tmp/ /tmp/
rsync -avx /media/var/log/ /var/log/

# Define fstab entries
FSTAB_ENTRIES=(
"/dev/mapper/vgubuntu-home /home ext4 defaults 0 2"
"/dev/mapper/vgubuntu-var /var ext4 defaults 0 2"
"/dev/mapper/vgubuntu-var_log /var/log ext4 defaults 0 2"
"/dev/mapper/vgubuntu-tmp /tmp ext4 defaults 0 2"
)

# Append new fstab entries if they are missing
for entry in "${FSTAB_ENTRIES[@]}"; do
    if ! grep -qF "$(echo "$entry" | awk '{print $2}')" /etc/fstab; then
        echo "$entry" | tee -a /etc/fstab
    else
        echo "Entry already exists for $(echo "$entry" | awk '{print $2}')"
    fi
done

# Notify user
echo "Partitions resized, data migrated, and /etc/fstab updated. Please verify with: cat /etc/fstab"

