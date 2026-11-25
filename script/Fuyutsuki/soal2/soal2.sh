#!/bin/sh
# Soal 2 - konfigurasi IP router Fuyutsuki
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ip link set lo up
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null
ip addr add 192.235.4.57/29 dev eth0
ip link set eth1 up
ip addr flush dev eth1 2>/dev/null
ip addr add 192.235.4.134/30 dev eth1
ip link set eth2 up
ip addr flush dev eth2 2>/dev/null
ip addr add 192.235.4.165/30 dev eth2
ip link set eth3 up
ip addr flush dev eth3 2>/dev/null
ip addr add 192.235.4.169/30 dev eth3
