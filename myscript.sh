#!/bin/bash

yum install google-chrome skypeforlinux.x86_64 zoom.x86_64 wps-office.x86_64 glade* slack.x86_64 fusioninventory-agent.x86_64  openvpn.x86_64 usbguard.x86_64  anydesk.x86_64 ntfs-3g.x86_64 -y 


if [ $? -eq 0 ]
then 
   echo "The installation of Packages is done Successfully"
  
else 
   echo "the installation of Packages is not done"

fi

echo "Enter the name"
read name
echo "Match user $name 
        PasswordAuthentication yes " >>/etc/ssh/sshd_config

echo "$name user is added inside '/etc/ssh/ssdh_config' file"


echo "$name ALL=NOPASSWD: /usr/sbin/openvpn *" >> /etc/sudoers

echo "$name ALL=NOPASSWD: /usr/bin/systemctl restart *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/mount *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/umount  *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/tail *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/less *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/kilall *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/sh *" >> /etc/sudoers

echo "$user has been assigned sudoer permission!"


# Define the source and destination paths for the first file
source_path1="/etc/yum.repos.d/google-chrome.repo"
destination_path1="/etc/yum.repos.d/online"

# Define the source and destination paths for the second file
source_path2="/etc/yum.repos.d/skype-stable.repo"
destination_path2="/etc/yum.repos.d/online"

# Function to move a file
move_file() {
  local source_path=$1
  local destination_path=$2

  # Check if the source file exists
  if [ -f "$source_path" ]; then
    # Move the file to the destination
    mv "$source_path" "$destination_path"
    echo "File $source_path moved to $destination_path"
  else
    echo "Source file $source_path not found!"
  fi
}

# Move the first file
move_file "$source_path1" "$destination_path1"

# Move the second file
move_file "$source_path2" "$destination_path2"


yum install kernel-ml-5.9.1-1.el7.elrepo.x86_64 -y

grub2-set-default 0

echo "The default kernel-ml-5.9.1-1.el7.elrepo.x86_64 has been installed, plz reboot once!

echo -e "allow with-interface one-of {03:01:02}  \nallow with-interface one-of {03:01:01}" > /etc/usbguard/rules.conf


