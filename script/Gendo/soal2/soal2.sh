#!/bin/sh
# Soal 2 - konfigurasi IP router Gendo
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ip link set lo up
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null
ip addr add 192.235.4.105/30 dev eth0
ip link set eth2 up
ip addr flush dev eth2 2>/dev/null
ip addr add 192.235.4.109/30 dev eth2
ip link set eth3 up
ip addr flush dev eth3 2>/dev/null
ip addr add 192.235.4.113/30 dev eth3
ip link set eth4 up
ip addr flush dev eth4 2>/dev/null
ip addr add 192.235.4.117/30 dev eth4
ip link set eth5 up
ip addr flush dev eth5 2>/dev/null
ip addr add 192.235.4.121/30 dev eth5
ip link set eth6 up
ip addr flush dev eth6 2>/dev/null
ip addr add 192.235.4.125/30 dev eth6
ip link set eth7 up
ip addr flush dev eth7 2>/dev/null
ip addr add 192.235.4.129/30 dev eth7
ip link set eth8 up
ip addr flush dev eth8 2>/dev/null
ip addr add 192.235.4.133/30 dev eth8
ip link set eth1 up
ip addr flush dev eth1 2>/dev/null
udhcpc -i eth1 -q -n -t 10 >/dev/null 2>&1 || true
