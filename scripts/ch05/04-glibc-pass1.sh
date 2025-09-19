#!/bin/bash

set -e

LOG_DIR="/home/twisper/lfs_project/logs/ch05/04-glibc-pass1"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

tar -xf glibc-2.42.tar.xz
cd glibc-2.42

case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

echo "Applying patch"
patch -Np1 -i ../glibc-2.42-fhs-1.patch
echo "Patch is done"

echo "Making build directory"
mkdir -v build
cd build
echo "rootsbindir=/usr/sbin" > configparms
echo "Directory is done"

(../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4) 2>&1 | tee "$LOG_DIR/configure.log"

make 2>&1 | tee "$LOG_DIR/make.log"
make DESTDIR=$LFS install 2>&1 | tee "$LOG_DIR/install.log"

echo "Cleaning sources"
cd $LFS/sources
rm -rfv glibc-2.42
echo "All done, ready for check"