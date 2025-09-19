#!/bin/bash

LOG_DIR="/home/twisper/lfs_project/logs/ch05/02-gcc-pass1"
mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd $LFS/sources

tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd       build

(../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.42 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++   
)2>&1 | tee "$LOG_DIR/configure.log"

make 2>&1 | tee "$LOG_DIR/make.log"
make install 2>&1 | tee "$LOG_DIR/install.log"

cd $LFS/sources/gcc-15.2.0
echo "Applying final adjustments"

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  "$(dirname "$($LFS_TGT-gcc -print-libgcc-file-name)")"/include/limits.h

echo "Cleaning"
cd $LFS/sources
rm -rfv gcc-15.2.0
echo "All done"