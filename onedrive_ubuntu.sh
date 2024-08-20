#!/bin/bash

apt install build-essential libcu10.40.1.11rl4-openssl-dev  libsqlite3-dev pkg-config git  curl  libnotify-dev

if [ $? -eq 0 ]
then
   echo "The installation of Packages is done Successfully"

else
   echo "the installation of Packages is not done"

fi

wget https://github.com/curl/curl/releases/download/curl-7_55_0/curl-7.55.0.tar.gz 

tar -xvf curl-7.55.0.tar.gz;cd curl-7.55.0/;./configure;make -j8;make install

curl -fsS https://dlang.org/install.sh | bash -s ldc-1.18.0

. ~/dlang/ldc-1.18.0/activate


# Clone the OneDrive repository

git clone https://github.com/abraunegg/onedrive.git || { echo "Error: Failed to clone OneDrive repository"; exit 1; }

# Configure, build, and install OneDrive

cd onedrive || { echo "Error: Failed to change directory to 'onedrive'"; exit 1; }
./configure || { echo "Error: Failed to configure OneDrive"; exit 1; }
make clean || { echo "Error: Failed to clean OneDrive build"; exit 1; }
make || { echo "Error: Failed to build OneDrive"; exit 1; }
make install || { echo "Error: Failed to install OneDrive"; exit 1; }

# Deactivate the virtual environment
deactivate || { echo "Warning: Failed to deactivate virtual environment"; }

config_file="/root/onedrive/config"
# Prompt the user for their name
read -p "Enter the username: " username
if [[ -z "$username" ]]; then
    echo "Error: Username cannot be empty"
    exit 1
fi

# Create necessary directories and set permissions
mkdir -p "/home/$username/.config/onedrive/" || { echo "Error: Failed to create directory"; exit 1; }
chown "$username:$username" "/home/$username/.config/onedrive/" -R || { echo "Error: Failed to set permissions"; exit 1; }

# Copy configuration file to user's directory
cp "$config_file" "/home/$username/.config/onedrive/" || { echo "Error: Failed to copy configuration file"; exit 1; }

# Create log directory and set permissions
mkdir -p /var/log/onedrive || { echo "Error: Failed to create log directory"; exit 1; }
chown "$username:$username" /var/log/onedrive/ -R || { echo "Error: Failed to set log directory permissions"; exit 1; }

echo "Setup completed successfully for user $username"



mkdir /var/log/onedrive

chown $username:$username /var/log/onedrive/ -R


# Define the configuration file path
new_file="/home/$username/.config/onedrive/config"

# Define the lines you want to uncomment
lines_to_uncomment=(
    "sync_dir = \"~/OneDrive\""
    "skip_file = \"~*|.~*|*.tmp\""
    "monitor_interval = \"300\""
    "skip_dir = \"\""
    "log_dir = \"/var/log/onedrive/\""
    "upload_only = \"false\""
)

# Loop through the lines and uncomment them in the config file
for line in "${lines_to_uncomment[@]}"; do
    # Use sed to uncomment the line in the config file
    sed -i "s|^# $line|$line|" "$new_file"
    sed -i '/^# skip_file = "~\*|.\~\*|\*.tmp"/ s/^# //' "$new_file"

done

#echo "Uncommented lines in the configuration file: $config_file"
echo "Modified and uncommented lines in the configuration file: $new_file"

sed -i "s|sync_dir = \"~/OneDrive\"|sync_dir = \"/mnt/Data/OneDrive\"|" "$new_file"



mkdir -p /mnt/Data/OneDrive/

chown $username:$username /mnt/Data/OneDrive -R

echo "created  Onedrive dir successfully"


# Define the cron job command
cron_job="30 11 * * 1 $username sh /mnt/Data/onedrive.sh"

# Add the cron job using crontab
(crontab -l ; echo "$cron_job") | crontab -

echo "Cron job added: $cron_job"


