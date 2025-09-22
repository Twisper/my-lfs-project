#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="07"
PKT_NAME="lz4"
VER_NAME="1.10.0"
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

echo "Compiling and testing ${PKT_NAME}"
make BUILD_STATIC=no PREFIX=/usr 2>&1 | tee "$LOG_DIR/make.log"
make -j1 check 2>&1 | tee "$LOG_DIR/check.log"

echo "Testing is done, check for results"
read -p "> "
echo "Installing ${PKT_NAME}"
make BUILD_STATIC=no PREFIX=/usr install 2>&1 | tee "$LOG_DIR/install.log"

echo "Installing done. Cleaning up"
cd "/sources"
rm -rfv "$FLD_NAME"
echo "All done"