#!/bin/bash

cd /etc/sysconfig/
cat > ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.64.100
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.64.255
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain <Your Domain Name>
nameserver <8.8.8.8>
nameserver <1.1.1.1>

# End /etc/resolv.conf
EOF

echo "FenOS" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts
HOSTNAME="mikhail-lfs"
127.0.0.1 localhost.localdomain localhost
127.0.1.1 ${HOSTNAME}
192.168.64.100 ${HOSTNAME}
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF