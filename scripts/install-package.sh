#!/bin/bash

set -e

TAR_NAME=$1

INSTALL_DIR="tmp/${TAR_NAME}"
PACKAGE_DIR="/lfs_project/packages"

echo "Creating package for ${TAR_NAME}"

make DESTDIR="$INSTALL_DIR" install

echo "Archiving package"
mkdir -p "$PACKAGE_DIR"
tar -cJf "${PACKAGE_DIR}/${TAR_NAME}.pkg.tar.xz" -C "$INSTALL_DIR" .

echo "Package created at ${PACKAGE_DIR}/${TAR_NAME}.pkg.tar.xz"

echo "Installing package"
tar -xpf "${PACKAGE_DIR}/${TAR_NAME}.pkg.tar.xz" -C /
echo "${PKG_NAME} installed successfully, cleaning up"
rm -rf "$INSTALL_DIR"
echo "All done"