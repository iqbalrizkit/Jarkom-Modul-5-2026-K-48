#!/bin/sh
# Soal 3 - IP sementara node uji Armisael
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.235.4.83/29 dev eth0
ip route replace default via 192.235.4.81
cat /proc/sys/net/ipv4/ip_forward 2>/dev/null || true
