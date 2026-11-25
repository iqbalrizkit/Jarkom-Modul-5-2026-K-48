#!/bin/sh
# Soal 3 - IP sementara node uji Comm-Net
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.235.2.2/24 dev eth0
ip route replace default via 192.235.2.1
cat /proc/sys/net/ipv4/ip_forward 2>/dev/null || true
