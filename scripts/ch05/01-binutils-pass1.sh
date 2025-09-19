#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch05/01-binutils-pass1"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

tar -xf binutils-2.45.tar.xz
cd binutils-2.45
echo "Unpacked binutils-2.45"

mkdir -v build
cd build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu 2>&1 | tee "$LOG_DIR/configure.log"

make 2>&1 | tee "$LOG_DIR/make.log"
make install 2>&1 | tee "$LOG_DIR/install.log"

echo "Cleaning"
cd $LFS/sources
rm -rv binutils-2.45
echo "All done"