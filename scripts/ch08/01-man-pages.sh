#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="01"
PKT_NAME="man-pages"
VER_NAME="6.15"
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

rm -v man3/crypt*

echo "Installing ${PKT_NAME}"
make -R GIT=false prefix=/usr install 2>&1 | tee "$LOG_DIR/install.log"

echo "Installing done. Cleaning up"
cd "/sources"
rm -rfv "$FLD_NAME"
echo "All done"