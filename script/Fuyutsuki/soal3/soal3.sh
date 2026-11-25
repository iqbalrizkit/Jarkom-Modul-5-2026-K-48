#!/bin/sh
# Soal 3 - routing statis router Fuyutsuki
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.133
ip route replace 192.235.3.192/27 via 192.235.4.166   # Maya
ip route replace 192.235.4.72/29 via 192.235.4.170   # Toji
