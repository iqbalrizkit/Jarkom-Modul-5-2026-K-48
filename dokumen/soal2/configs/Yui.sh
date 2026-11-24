#!/bin/sh
# Soal 2 - konfigurasi IP router Yui
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ip link set lo up
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null
ip addr add 192.235.3.1/25 dev eth0
ip link set eth1 up
ip addr flush dev eth1 2>/dev/null
ip addr add 192.235.4.110/30 dev eth1
ip link set eth2 up
ip addr flush dev eth2 2>/dev/null
ip addr add 192.235.4.137/30 dev eth2
ip link set eth3 up
ip addr flush dev eth3 2>/dev/null
ip addr add 192.235.4.141/30 dev eth3
ip link set eth4 up
ip addr flush dev eth4 2>/dev/null
ip addr add 192.235.4.145/30 dev eth4
