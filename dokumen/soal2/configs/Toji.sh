#!/bin/sh
# Soal 2 - konfigurasi IP router Toji
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ip link set lo up
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null
ip addr add 192.235.4.73/29 dev eth0
ip link set eth1 up
ip addr flush dev eth1 2>/dev/null
ip addr add 192.235.4.170/30 dev eth1
