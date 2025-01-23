#!/bin/bash

if [[ "$(whoami)" != "root" ]]; then
  echo "This script must be run as root."
  exit 1
fi
DIR=""

# Rest of your script's code here
echo "Script running as root."

# Define colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"


yum  groupinstall 'Development Tools' -y && yum install libcurl-devel sqlite-devel libnotify-devel -y
if [ $? -eq 0 ]
then
   echo -e ${GREEN} "The installation of Packages is done Successfully"${RESET}

else
   echo -e ${RED} "the installation of Packages is not done"${RESET}

fi

curl -fsS https://dlang.org/install.sh | bash -s ldc-1.18.0 

source ~/dlang/ldc-1.18.0/activate


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
mkdir -p /var/log/onedrive 
chown "$username:$username" /var/log/onedrive/ -R 
echo "Setup completed successfully for user $username"

 

# Define the configuration file path
new_file="/home/$username/.config/onedrive/config"



# Check if /mnt/Data exists
if [ -d "/mnt/Data" ]; then
    DIR="/mnt/Data/OneDrive"
else
    DIR="/mnt/Data1/OneDrive"
fi

mkdir -p "$DIR"


# Define the lines you want to uncomment
#sed -i 's/^# sync_dir =/sync_dir=\/mnt\/Data1\/OneDrive/' /home/$username/.config/onedrive/config
#sed -i "s|^# sync_dir =.*|sync_dir = "$DIR"|" /home/$username/.config/onedrive/config
sed -i "s|^# sync_dir =.*|sync_dir = \"$DIR\"|" /home/$username/.config/onedrive/config
sed -i 's/^# skip_file/skip_file/' /home/$username/.config/onedrive/config
sed -i 's/^# monitor_interval/monitor_interval/' /home/$username/.config/onedrive/config
sed -i 's/^# skip_dir = ""/skip_dir = ""/' /home/$username/.config/onedrive/config
sed -i 's/^# log_dir/log_dir/' /home/$username/.config/onedrive/config
sed -i 's/^# upload_only/upload_only/' /home/$username/.config/onedrive/config

#echo "Uncommented lines in the configuration file: $config_file"
#echo "Modified and uncommented lines in the configuration file: $new_file"

#sed -i "s|sync_dir = \"~/OneDrive\"|sync_dir = \"/mnt/Data1/OneDrive\"|" "$new_file"



#mkdir -p "$DIR"

echo "created  Onedrive dir successfully"



# Create the onedrive.sh file in the selected directory
cat <<EOF > "$DIR/onedrive.sh"
#!/bin/bash

sudo systemctl stop onedrive@alex.service
if [ $? = 0 ]
then
echo -e "`date` stoped onedrive" > /home/$username/onedrive.log 
fi

rsync -avzP /home/$username/.thunderbird  "$DIR"
if [ $? = 0 ]
then
echo -e "`date` data copied" >> /home/$username/onedrive.log
fi

sudo systemctl start onedrive@alex.service
if [ $? = 0 ]
then
echo -e "`date` started onedrive" >> /home/$usename/onedrive.log
fi

/usr/local/bin/onedrive --synchronize
if [ $? = 0 ]
then
echo -e "`date` sync" >> /home/$username/onedrive.log
fi
echo -e "`date` script ran successfully" >> /home/$username/onedrive.log
EOF

# Make the onedrive.sh script executable

chown $username:$username "$DIR" -R

chmod +x "$DIR/onedrive.sh"


echo "onedrive.sh has been created and made executable at $DIR/onedrive.sh"



# Define the cron job command
cron_job="30 11 * * 1 $username /bin/bash "$DIR/onedrive.sh""

# Add the cron job using crontab
(crontab -l ; echo "$cron_job") | crontab -

echo "Cron job added: $cron_job"

