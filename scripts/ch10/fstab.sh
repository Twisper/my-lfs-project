#!/bin/bash

LFS_ROOT_UUID="723c654c-83ee-4c4f-94e8-3f41558456ff"
LFS_SWAP_UUID="b506ff07-8e4a-4692-b864-a92432084d49"
LFS_ESP_UUID="2580-C938"

cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

UUID=${LFS_ROOT_UUID}     /              ext4     defaults            1     1
UUID=${LFS_SWAP_UUID}     swap           swap     pri=1               0     0
UUID=${LFS_ESP_UUID} /boot/efi vfat codepage=437,iocharset=iso8859-1 0 1
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOF