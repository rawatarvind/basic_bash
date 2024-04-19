#! /bin/bash
echo "Enter the name"
read name

echo "$name user is added inside '/etc/ssh/ssdh_config' file"


echo "$name ALL=NOPASSWD: /usr/sbin/openvpn *" >> /etc/sudoers

echo "$name ALL=NOPASSWD: /usr/bin/systemctl restart *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/mount *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/umount  *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/tail *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/less *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/kilall *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/sh *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/yum install *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/yum remove *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/yum update *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/yum update *" >> /etc/sudoers
echo "$name ALL=NOPASSWD: /bin/chmod, /bin/chown"  >> /etc/sudoers
echo "$name ALL=NOPASSWD: /usr/bin/vim /etc/fstab, /sbin/fdisk"  >> /etc/sudoers
echo "$name ALL=NOPASSWD: /bin/chmod, /bin/chown"  >> /etc/sudoers
echo "$name ALL=NOPASSWD:  /sbin/pvcreate, /sbin/vgcreate, /sbin/lvcreate, /sbin/pvremove, /sbin/vgremove, /sbin/lvremove, /sbin/pvdisplay, /sbin/vgdisplay, /sbin/lvdisplay, /sbin/pvscan, /sbin/vgscan, /sbin/lvscan" >> /etc/sudoers
echo "$user has been assigned sudoer permission!"

