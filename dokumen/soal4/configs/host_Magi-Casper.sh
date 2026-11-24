#!/bin/sh
# Soal 4 - IP sementara agar node pemasang paket bisa resolv DNS
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.235.4.58/29 dev eth0
ip route replace default via 192.235.4.57
