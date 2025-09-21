#!/bin/bash

set -e

CHPTR_NUM="08"
PKT_NUM="03"
PKT_NAME="glibc"
VER_NAME="2.42"
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

patch -Np1 -i ../glibc-2.42-fhs-1.patch

sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
  __libc_rwlock_define_initialized (, reset_lock);\
  memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

(
    ../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Building and installing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"

touch /etc/ld.so.conf

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install 2>&1 | tee "$LOG_DIR/install.log"
echo "Done. Ready for testing"