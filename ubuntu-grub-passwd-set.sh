#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (sudo)"
  exit 1
fi

# Configuration
GRUB_USER="admin"
PASSWORD_FILE="/etc/grub.d/01_password"
LINUX_CONFIG="/etc/grub.d/10_linux"

# 1. Securely ask for password with confirmation
while true; do
    read -rs -p "Enter GRUB password: " PASS1
    echo
    read -rs -p "Confirm GRUB password: " PASS2
    echo
    
    if [ "$PASS1" = "$PASS2" ] && [ -n "$PASS1" ]; then
        echo "Passwords match. Generating hash..."
        # Pass the password to the generator via stdin
        GRUB_HASH=$(echo -e "$PASS1\n$PASS1" | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf2/ {print $NF}')
        break
    else
        echo "Passwords do not match or are empty. Please try again."
    fi
done

if [ -z "$GRUB_HASH" ]; then
    echo "Error: Password hash generation failed."
    exit 1
fi

# 2. Create the GRUB password config file
cat <<EOF > "$PASSWORD_FILE"
#!/bin/sh
exec tail -n +3 \$0
set superusers="$GRUB_USER"
password_pbkdf2 $GRUB_USER $GRUB_HASH
EOF

chmod 755 "$PASSWORD_FILE"

# 3. Apply --unrestricted flag
echo "Updating $LINUX_CONFIG with --unrestricted flag..."
sed -i 's/--class os/--class os --unrestricted/g' "$LINUX_CONFIG"
# Remove duplicates if script is run twice
sed -i 's/--unrestricted --unrestricted/--unrestricted/g' "$LINUX_CONFIG"

# 4. Update GRUB
echo "Applying changes to GRUB..."
update-grub

echo "Success! Password set for $GRUB_USER."
