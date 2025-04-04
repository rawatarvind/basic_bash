#!/bin/bash

# Existing directory are in system or not

if [ -d '/mnt/Data/' ]; then
    ls -ltrh /mnt/Data
else
    ls -ltrh /mnt/Data1
fi


# existing file in system.

if [ -f '/home/sarvind/test.sh' ]; then
   cat /home/sarvind/test.sh
else 
   echo "file not exists"
fi
