#!/bin/bash

set -e

PACKET_NAME="ncurses-6.5-20250809.tgz"
FOLDER_NAME="ncurses-6.5-20250809"

LOG_DIR="/home/twisper/lfs_project/logs/ch06/02-ncurses"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

echo "Unpacking ncurses"
tar -xf "$PACKET_NAME"
cd "$FOLDER_NAME"
echo "Unpacked"

echo "Building and installing tic"
mkdir build
pushd build
  ../configure --prefix=$LFS/tools AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $LFS/tools/bin
popd

echo "Installing is done"

cd $LFS/sources
rm -rfv "$FOLDER_NAME"

echo "Unpacking Ncurses"
tar -xf "$PACKET_NAME"
cd "$FOLDER_NAME"
echo "Unpacked"

(./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing Ncurses"
make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

echo "Done. Cleaning up"

cd $LFS/sources
rm -rfv "$FOLDER_NAME"
echo "All done"