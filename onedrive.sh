#!/bin/bash

echo "Enter the name"
read name

sudo systemctl stop onedrive@alex.service
if [ $? = 0 ]
then
echo -e "`date` stoped onedrive" > /home/$name/onedrive.log 
fi

rsync -avzP /home/$name/.thunderbird/  /mnt/Data/OneDrive/
if [ $? = 0 ]
then
echo -e "`date` data copied" >> /home/$name/onedrive.log
fi

sudo systemctl start onedrive@alex.service
if [ $? = 0 ]
then
echo -e "`date` started onedrive" >> /home/$name/onedrive.log
fi

/usr/local/bin/onedrive --synchronize
if [ $? = 0 ]
then
echo -e "`date` sync" >> /home/$name/onedrive.log
fi
echo -e "`date` script ran successfully" >> /home/$name/onedrive.log
