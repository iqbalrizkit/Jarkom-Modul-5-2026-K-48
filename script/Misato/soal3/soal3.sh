#!/bin/sh
# Soal 3 - routing statis router Misato
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.125
