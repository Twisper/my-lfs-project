#!/bin/bash

set -e

CHPTR_NUM="07"
PKT_NUM="05"
PKT_NAME="texinfo"
VER_NAME="7.2"
ARH_NAME="tar.xz"
LOG_DIR="/lfs_project/logs/ch${CHPTR_NUM}/${PKT_NUM}-${PKT_NAME}"
FLD_NAME="${PKT_NAME}-${VER_NAME}"
TAR_NAME="$FLD_NAME.${ARH_NAME}"

mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd /sources

echo "Unpacking ${PKT_NAME}"
tar -xf "$TAR_NAME"
cd "$FLD_NAME"
echo "Unpacking done"

(
    ./configure --prefix=/usr
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"
make install 2>&1 | tee "$LOG_DIR/install.log"

echo "Installing done. Cleaning up"
cd "/sources"
rm -rfv "$FLD_NAME"
echo "All done"