#!/bin/bash

set -e

PKT_NUM="05"
PKT_NAME="file"
VER_NAME="5.46"
ARH_NAME="tar.gz"
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

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

(./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing ${PKT_NAME}"
make FILE_COMPILE=$(pwd)/build/src/file 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install | tee 2>&1 "$LOG_DIR/install.log"

echo "Installing done. Cleaning up"
cd "$LFS/sources"
rm -v $LFS/usr/lib/libmagic.la
rm -rfv "$FLD_NAME"
echo "All done"