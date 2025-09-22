#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="06"
PKT_NAME="xz"
VER_NAME="5.8.1"
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
    ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-${VER_NAME}
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
rm -rfv "$FLD_NAME"
echo "All done"