#!/bin/bash

set -e

PKT_NUM="16"
PKT_NAME="binutils"
VER_NAME="2.45"
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

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
cd       build

(
    ../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install | tee 2>&1 "$LOG_DIR/install.log"

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

echo "Installing done. Cleaning up"
cd "$LFS/sources"
rm -rfv "$FLD_NAME"
echo "All done"