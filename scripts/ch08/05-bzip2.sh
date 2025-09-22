#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="05"
PKT_NAME="bzip2"
VER_NAME="1.0.8"
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

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so 
make clean

echo "Compiling ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"

echo "Installing ${PKT_NAME}"
make PREFIX=/usr install 2>&1 | tee "$LOG_DIR/install.log"

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

echo "Installing done. Cleaning up"
cd "/sources"
rm -fv /usr/lib/libbz2.a
rm -rfv "$FLD_NAME"
echo "All done"