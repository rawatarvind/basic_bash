#!/bin/bash

yum install google-chrome skypeforlinux.x86_64 zoom.x86_64 wps-office.x86_64 glade* slack.x86_64 fusioninventory-agent.x86_64  openvpn.x86_64 usbguard.x86_64  anydesk.x86_64 ntfs-3g.x86_64 kernel-ml-5.9.1-1.el7.elrepo.x86_64 -y 


if [ $? -eq 0 ]
then 
   echo "The installation of Packages is done Successfully"
  
else 
   echo "the installation of Packages is not done"

fi

# Prompt username and create a new user .

echo "Enter the name"
read name
useradd $name
echo "$name is created successfully"

# Set the password for $name user.

echo "Set password of $name"
sudo passwd "$name"

# Add match user in  sshd_config file. 

echo "Match user $name 
        PasswordAuthentication yes " >>/etc/ssh/sshd_config

echo "$name user is added inside '/etc/ssh/ssdh_config' file"

# Give sudo access of some services to $name user.

echo "$name ALL=NOPASSWD: /usr/sbin/openvpn *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/systemctl restart *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/systemctl start onedrive@alex.service" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/systemctl stop onedrive@alex.service" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/mount *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/umount  *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/tail *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/less *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/kilall *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/sh *" >> /etc/sudoers

echo "$name has been assigned sudoer permission!"

# Set the UID for "$name" user

echo "Enter the UID"
read uid

if [[ $uid -gt 1000 ]]; then
     sudo usermod -u "$uid" "$name"
else
     echo "Later add uid for $name,as it is less than 1000."
fi

# Add group name  and set the GID. 

echo "Enter the Group Name"
read groupname
sudo groupadd "$groupname"
echo "$groupname  group is created successfully"

echo "Enter the GID"
read guid

if [[ $guid -gt 1000 ]]; then
     sudo groupmod -g $guid $groupname
else
     echo "later add the GID for $groupname, as it is less than 1000."
fi

# Add the user to the Group

if [[ $guid -gt 1000 ]]; then
    sudo usermod -g "$groupname" "$name"
    echo "$name has been added to $groupname."
else 
    echo "Add user to the Group later"

fi

echo "$(id $name)"



# VLC installed from flatpak

 sudo  yum install flatpak -y

# Add repo of flatpak.

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install flathub org.videolan.VLC -y

echo "Vlc installed successfully"

# Set default kernel-5.9 

grub2-set-default 0

echo "The default kernel-ml-5.9.1-1.el7.elrepo.x86_64 has been installed, plz reboot once!"

echo -e "allow with-interface one-of {03:01:02}  \nallow with-interface one-of {03:01:01}" > /etc/usbguard/rules.conf

if [ $? -eq 0 ] 
then
    echo "script run successfully, installed all packages,set kernel 5.9 as default "
else
    echo "check the error"
fi
