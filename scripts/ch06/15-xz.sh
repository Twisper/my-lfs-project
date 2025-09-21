#!/bin/bash

set -e

PKT_NUM="15"
PKT_NAME="xz"
VER_NAME="5.8.1"
ARH_NAME="tar.xz"
LOG_DIR="/home/twisper/lfs_project/logs/ch06/${PKT_NUM}-${PKT_NAME}"
FLD_NAME="${PKT_NAME}-${VER_NAME}"
TAR_NAME="$FLD_NAME.${ARH_NAME}"

mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking ${PKT_NAME}"
tar -xf "$TAR_NAME"
cd "$FLD_NAME"
echo "Unpacking done"

(
    ./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-${VER_NAME}
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"

rm -v $LFS/usr/lib/liblzma.la

echo "Installing done. Cleaning up"
cd "$LFS/sources"
rm -rfv "$FLD_NAME"
echo "All done"