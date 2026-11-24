#!/bin/sh
# Soal 3 - routing statis router Shigeru
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.129
ip route replace 192.235.4.88/29 via 192.235.4.162   # Makoto
