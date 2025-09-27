#!/bin/bash

bash /usr/lib/udev/init-net-rules.sh

sed -e '/^AlternativeNamesPolicy/s/=.*$/=/'  \
       /usr/lib/udev/network/99-default.link \
     > /etc/udev/network/99-default.link

#sed -e 's/"write_cd_rules"/"write_cd_rules mode"/' \
#    -i /etc/udev/rules.d/83-cdrom-symlinks.rules

cat > /etc/udev/rules.d/75-cd-aliases.rules << "EOF"
# Begin /etc/udev/rules.d/75-cd-aliases.rules

# Aliases for CD/DVD devices
KERNEL=="sr[0-9]*", ENV{ID_CDROM}=="1", SYMLINK+="cdrom"
KERNEL=="sr[0-9]*", ENV{ID_CDROM_DVD}=="1", SYMLINK+="dvd"

# Aliases for CD/DVD writers
KERNEL=="sr[0-9]*", ENV{ID_CDROM_CD_R}=="1", SYMLINK+="cdrw"
KERNEL=="sr[0-9]*", ENV{ID_CDROM_CD_RW}=="1", SYMLINK+="cdrw"
KERNEL=="sr[0-9]*", ENV{ID_CDROM_DVD_R}=="1", SYMLINK+="dvdrw"
KERNEL=="sr[0-9]*", ENV{ID_CDROM_DVD_RW}=="1", SYMLINK+="dvdrw"

# End /etc/udev/rules.d/75-cd-aliases.rules
EOF