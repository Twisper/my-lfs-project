#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch06/03-bash"
VER_NAME="5.3"
FLD_NAME="$LFS/sources/bash-${VER_NAME}"
TAR_NAME="$FLD_NAME.tar.gz"

mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking bash"
tar -xf "$TAR_NAME"
cd "$FLD_NAME"
echo "Unpacking done"

(./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing Bash"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install | tee 2>&1 "$LOG_DIR/install.log"
ln -sv bash $LFS/bin/sh

echo "Installing done. Cleaning up"
cd "$LFS/sources"
rm -rfv "$FLD_NAME"
echo "All done"