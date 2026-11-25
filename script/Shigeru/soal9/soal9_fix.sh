#!/bin/sh
# Soal 9 - perbaikan jalur belakang Shigeru (idempoten)
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route del blackhole 192.235.4.72/29 2>/dev/null || true
ip rule del iif eth0 lookup 100 2>/dev/null || true
ip route del default table 100 2>/dev/null || true
ip route replace default via 192.235.4.129 dev eth1
ip route replace 192.235.4.88/29 via 192.235.4.162 dev eth2
echo "Shigeru diperbaiki: forwarding aktif, default via Gendo, blackhole & policy rule dihapus"
ip rule
ip route show table 100 || true
ip route
cat /proc/sys/net/ipv4/ip_forward
