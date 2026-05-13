#!/bin/bash

# Check if a username was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    echo "Example: $0 sudipd"
    exit 1
fi

TARGET_USER="$1"

# 1. Fetch user data from polo using the argument $1
USER_DATA=$(ssh -q sarvind@polo "ypcat passwd | grep '^${TARGET_USER}:'" 2>/dev/null | tr -d '\r')

if [ -z "$USER_DATA" ]; then
    echo "Error: Could not find user '${TARGET_USER}' on polo NIS maps."
    exit 1
fi

# 2. Extract fields and trim whitespace
EXT_USER=$(echo "$USER_DATA" | cut -d: -f1 | xargs)
EXT_UID=$(echo "$USER_DATA" | cut -d: -f3 | xargs)
EXT_GID=$(echo "$USER_DATA" | cut -d: -f4 | xargs)
EXT_NAME=$(echo "$USER_DATA" | cut -d: -f5 | xargs)

# 3. Fetch the Group Name dynamically from the GID
EXT_GROUP=$(ssh -q sarvind@polo "ypcat group | grep ':.*:${EXT_GID}:'" 2>/dev/null | cut -d: -f1 | xargs)

# Fallback if group lookup fails
if [ -z "$EXT_GROUP" ]; then
    EXT_GROUP="installation"
fi

# 4. Path to your vars file
VARS_FILE="roles/user_mgmt/vars/main.yml"

# 5. Write the file
cat <<EOF > "$VARS_FILE"
# user details
new_user: $EXT_USER
new_password: "${EXT_USER}123"
user_uid: $EXT_UID
user_group: "$EXT_GROUP"
group_gid: $EXT_GID
username: "$EXT_NAME"
EOF

echo "------------------------------------------"
echo "Successfully updated $VARS_FILE"
echo "Target User: $EXT_USER"
echo "UID/GID:     $EXT_UID / $EXT_GID"
echo "Group Name:  $EXT_GROUP"
echo "------------------------------------------"
