#!/bin/bash
echo "Enter the username:"
read name
sudo useradd $name
 echo "$name is created successfully"

echo `sudo passwd $name`

echo "enter the uid"
read num
sudo usermod -u $num $name
echo `sudo id $name`
