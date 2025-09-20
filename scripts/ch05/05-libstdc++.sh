#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch05/05-libstdc++"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking gcc"
tar -xf "gcc-15.2.0.tar.xz"
cd gcc-15.2.0
echo "Gcc is ready"

mkdir -v build
cd build

(../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Compiling packets"
make 2>&1 | tee "$LOG_DIR/make.log"
echo "Installing packets"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"
echo "Installing done"

echo "Cleaning..."
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
cd $LFS/sources
rm -rfv gcc-15.2.0
echo "All done"