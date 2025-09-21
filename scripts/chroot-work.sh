#!/bin/bash

set -e

if ! findmnt -v | grep -q "$LFS"; then
    echo "LFS partition is not mounted. Mounting..."
    mount -v -L LFS $LFS
fi

echo "Mounting virtual kernel filesystems..."
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

mount --bind /home/twisper/lfs_project $LFS/lfs_project

echo "Entering chroot. Type exit to return"

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j7"      \
    TESTSUITEFLAGS="-j7" \
    /bin/bash --login

echo "Exited chroot. Cleaning up"

echo "Unmounting LFS chroot environment"

echo "Unbinding project directories..."
umount $LFS/lfs-project

echo "Unmounting virtual kernel filesystems"
umount $LFS/dev/pts
umount $LFS/dev/shm
umount $LFS/dev
umount $LFS/proc
umount $LFS/sys
umount $LFS/run

echo "Chroot environment successfully unmounted"