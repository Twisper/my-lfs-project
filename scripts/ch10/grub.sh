#!/bin/bash

LFS_ROOT_UUID="723c654c-83ee-4c4f-94e8-3f41558456ff"


cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)
set gfxpayload=1024x768x32

menuentry "GNU/Linux, Linux 6.16.1-lfs-12.4" {
        linux   /boot/vmlinuz-6.16.1-lfs-12.4 root=UUID=${LFS_ROOT_UUID} ro
}
EOF