#!/bin/bash

set -e

PACKAGE_FILE=$1

if [ -z "$PACKAGE_FILE" ]; then
    echo "Error: Please provide the path to the package file"
    exit 1
fi

if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: Package file not found at $PACKAGE_FILE"
    exit 1
fi

echo "Preparing to remove package $PACKAGE_FILE"

echo "Reading file list from package"
FILE_LIST=$(sudo tar -tf "$PACKAGE_FILE")

echo "Removing installed files"
echo "$FILE_LIST" | xargs -I {} sudo rm -v /{}

echo "Cleaning up empty directories"
echo "$FILE_LIST" | grep '/$' | sort -r | xargs -I {} sudo rmdir -v /{} || true

echo "Package removed"