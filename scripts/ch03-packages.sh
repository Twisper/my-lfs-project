#!/bin/bash

set -e

LFS_PATH="https://linuxfromscratch.org/lfs/view/stable-systemd/"

PACKAGES="wget-list"
MD5SUMS_PACKAGES="md5sums"

echo "Creating directory ./sources"
mkdir -pv ./sources
echo "Finished creating directory ./sources"

cd ./sources

echo "Downloading list of packets and their MD5 sums"
wget "${LFS_PATH}${PACKAGES}" -N
wget "${LFS_PATH}${MD5SUMS_PACKAGES}" -N
echo "Download completed"

echo "Downloading packets"
wget --input-file=wget-list --continue --directory-prefix=.
echo "Download completed"

echo "Checking packets' MD5 sums"
if md5sum -c md5sums; then
    echo "Completed"
else
    echo "Some files are corrupted, you should check"
    exit 1
fi