#!/bin/bash

set -e

PKT_NAME=$(basename "$0" | sed -e 's/^[0-9]\+-//' -e 's/\.sh$//')

PKT_NUM=$(basename "$0" | sed 's/-.*//')

CHPTR_DIR=$(dirname "$0")
CHPTR_NUM=$(basename "$CHPTR_DIR" | sed 's/ch//')

TAR_NAME=$(find . -maxdepth 1 -name "${PKT_NAME}-*.tar.*" | head -n 1)

if [[ -z "$TAR_NAME" ]]; then
    echo "ERROR: No package with name ${PKT_NAME} found in /sources!"
    exit 1
fi

FLD_NAME=$(basename "$TAR_NAME" | sed 's/\.tar\..*$//')
VER_NAME=$(echo "$FLD_NAME" | sed "s/^${PKT_NAME}-//")

LOG_DIR="/lfs_project/logs/ch${CHPTR_NUM}/${PKT_NUM}-${PKT_NAME}"



mkdir -p "$LOG_DIR"
echo "Created logging directory"

cd /sources

echo "Unpacking ${PKT_NAME}"
tar -xf "$TAR_NAME"
cd "$FLD_NAME"
echo "Unpacking done"

mkdir -v build
cd       build

(
    ../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck
) 2>&1 | tee "$LOG_DIR/configure.log"

echo "Compiling and testing ${PKT_NAME}"
make 2>&1 | tee "$LOG_DIR/make.log"

make check 2>&1 | tee "$LOG_DIR/check.log"
echo "Testing is done, check for results"
read -p "> "

echo "Installing ${PKT_NAME}"
make install 2>&1 | tee "$LOG_DIR/install.log"
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf

echo "Installing done. Cleaning up"
cd "/sources"
rm -rfv "$FLD_NAME"
echo "All done"