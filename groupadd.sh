#!/bin/bash

echo "Enter the Groupname"
read name
sudo groupadd $name
ehco "$name group has been created!"

echo "Enter the Gid"
read num

sudo groupmod -g $num $name

echo `cat /etc/group | grep $name`
