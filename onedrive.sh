#!/bin/bash

sudo systemctl stop onedrive@alex.service
if [ $? = 0 ]
then
echo -e "`date` stoped onedrive" > /home/$name/onedrive.log 
fi

rsync -avzP /home/$name/.thunderbird/  /mnt/Data/OneDrive/
if [ $? = 0 ]
then
echo -e "`date` data copied" >> /home/$name/onedrive.log
email_body="The backup of sarvind to OneDrive completed successfully on $(date)."
echo "$email_body" | mail -s "status of onedrive backup of sarvind" sarvind@vehant.com
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
