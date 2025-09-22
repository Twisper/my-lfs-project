#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="04"
PKT_NAME="zlib"
VER_NAME="1.3.1"
ARH_NAME="tar.gz"
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

echo "Compiling and testing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"
make check 2>&1 | tee "$LOG_DIR/check.log"

echo "Testing is done, check for results"
read -p "> "
echo "Installing ${PKT_NAME}"
make install 2>&1 | tee "$LOG_DIR/install.log"

echo "Installing done. Cleaning up"
cd "/sources"
rm -fv /usr/lib/libz.a
rm -rfv "$FLD_NAME"
echo "All done"