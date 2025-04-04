#!/bin/bash

# Define source directories
BACKUP_SRC1="/home/username"
BACKUP_SRC2="/mnt/Data1"
BACKUP_SRC3="/mnt/Data2"
BACKUP_SRC4="/mnt/Data3"
BACKUP_SRC5="/mnt/Data4"

# Define external drive UUID and mount point
BACKUP_DRIVE_UUID="4EA9-49D0-4568"  # Replace this with your external drive UUID
BACKUP_MOUNT="/run/media/username/"

# Define backup destinations
BACKUP_DEST1="$BACKUP_MOUNT/home_backup"
BACKUP_DEST2="$BACKUP_MOUNT/data1_backup"
BACKUP_DEST3="$BACKUP_MOUNT/data2_backup"
BACKUP_DEST4="$BACKUP_MOUNT/data3_backup"
BACKUP_DEST5="$BACKUP_MOUNT/data4_backup"

# Function to perform backup
backup_directory() {
    SRC="$1"
    DEST="$2"
    echo "Starting backup of $SRC..."
    rsync -av --delete "$SRC/" "$DEST/"
    
    if [ $? -eq 0 ]; then
        echo "Backup of $SRC completed successfully."
        return 0
    else
        echo "Backup of $SRC failed."
        return 1
    fi
}

# Check if the external drive is connected
if ! lsblk -f | grep -q "$BACKUP_DRIVE_UUID"; then
    echo "External drive not detected."
    exit 1
fi

# Ensure the mount point exists
if [ ! -d "$BACKUP_MOUNT" ]; then
    echo "Mount point does not exist. Trying to mount..."
    sudo mkdir -p "$BACKUP_MOUNT"
    sudo mount UUID="$BACKUP_DRIVE_UUID" "$BACKUP_MOUNT"
fi

# Start backup of /home
backup_directory "$BACKUP_SRC1" "$BACKUP_DEST1"

# If /home backup is successful, then proceed with /mnt backups
if [ $? -eq 0 ]; then
    backup_directory "$BACKUP_SRC2" "$BACKUP_DEST2"
    backup_directory "$BACKUP_SRC3" "$BACKUP_DEST3"
    backup_directory "$BACKUP_SRC4" "$BACKUP_DEST4"
    backup_directory "$BACKUP_SRC5" "$BACKUP_DEST5"
else
    echo "Skipping /mnt backups as /home backup failed."
fi

echo "Backup process completed."

exit 0

