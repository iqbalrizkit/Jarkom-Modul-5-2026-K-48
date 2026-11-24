#!/bin/sh
# Soal 3 - routing statis router Yui
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.109
ip route replace 192.235.0.0/23 via 192.235.4.138   # Rei
ip route replace 192.235.4.0/27 via 192.235.4.142   # Shinji
ip route replace 192.235.4.32/28 via 192.235.4.146   # Mari
