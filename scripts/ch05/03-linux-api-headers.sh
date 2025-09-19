#!/bin/bash

LOG_DIR="/home/twisper/lfs_project/logs/ch05/03-linux-api-headers"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

tar -xf linux-6.16.1.tar.xz
cd linux-6.16.1

echo "Cleaning sources"
make mrproper 2>&1 | tee "$LOG_DIR/mrproper.log"
echo "Done cleaning sources"

echo "Installing headers"
make headers 2>&1 | tee "$LOG_DIR/headers.log"
echo "Done installing headers"

find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

echo "Cleaning all directories"
cd $LFS/sources
rm -rfv linux-6.16.1
echo "All done"