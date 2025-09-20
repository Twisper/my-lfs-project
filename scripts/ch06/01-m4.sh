#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch06/01-m4"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking M4"
tar -xf "m4-1.4.20.tar.xz"
cd m4-1.4.20
echo "Unpacking is done"

(./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Compiling and installing M4"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"
echo "Installing complete"

echo "Cleaning up..."
cd $LFS/sources
rm -rfv m4-1.4.20
echo "All done"