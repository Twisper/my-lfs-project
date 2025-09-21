#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="03"
PKT_NAME="glibc"
VER_NAME="2.42"
ARH_NAME="tar.xz"
LOG_DIR="/home/twisper/lfs_project/logs/ch${CHPTR_NUM}/${PKT_NUM}-${PKT_NAME}"
FLD_NAME="${PKT_NAME}-${VER_NAME}"
TAR_NAME="$FLD_NAME.${ARH_NAME}"

cd "$FLD_NAME"
echo "Unpacking done"

cd       build

echo "Testing ${PKT_NAME}"
make check 2>&1 | tee "$LOG_DIR/check.log"
grep "Timed out" $(find -name \*.out)
echo "Done. Ready for configuring"