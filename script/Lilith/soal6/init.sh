#!/bin/sh
# Soal 6 - IP permanen Lilith (192.235.4.72/29)
# Dijalankan otomatis oleh /etc/alpinet-init.sh / /etc/debinet-init.sh
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.235.4.74/29 dev eth0
ip route replace default via 192.235.4.73
cat > /etc/resolv.conf <<'EOF'
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
cat > /etc/network/interfaces <<'EOF'
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.235.4.74
    netmask 255.255.255.248
    gateway 192.235.4.73
EOF
