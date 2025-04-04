#!/bin/bash

#Increase Swap Size to 8GB

swapoff /dev/mapper/vgubuntu-swap_1  

lvresize -L 8G /dev/mapper/vgubuntu-swap_1

mkswap /dev/mapper/vgubuntu-swap_1

swapon /dev/mapper/vgubuntu-swap_1

# Encrypt /mnt Partitions

vgcreate vg1 /dev/nvme1n1 

#Create logical Volumes

lvcreate -L 200G -n mnt_data1 vg1

lvcreate -L 200G -n mnt_data2 vg1

#Encrypt Partitions:(use same encrytion password)

cryptsetup luksFormat /dev/mapper/vg1-mnt_data1
cryptsetup luksFormat /dev/mapper/vg1-mnt_data2

