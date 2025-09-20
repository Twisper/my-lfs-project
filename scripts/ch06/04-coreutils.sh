#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch06/04-coreutils"
VER_NAME="9.7"
FLD_NAME="coreutils-${VER_NAME}"
TAR_NAME="$FLD_NAME.tar.xz"

mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking coreutils"
tar -xf "$TAR_NAME"
cd "$FLD_NAME"
echo "Unpacking done"

(./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing Coreutils"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"

mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

echo "Installing done. Cleaning up"
cd "$LFS/sources"
rm -rfv "$FLD_NAME"
echo "All done"