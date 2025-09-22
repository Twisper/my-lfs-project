#!/bin-bash
set -e

cd ./ch08

echo "Starting batch commit process..."

for script_file in $(git ls-files --others --exclude-standard *.sh); do
  
  PKG_NAME=$(echo "$script_file" | sed -e 's/^[0-9]\+-//' -e 's/\.sh$//')
  
  echo "Committing script for ${PKG_NAME}..."
  
  git add "$script_file"
  
  git commit -m "Feat(ch08): Added script for ${PKG_NAME} building and installing"
done

echo "Batch commit process finished!"