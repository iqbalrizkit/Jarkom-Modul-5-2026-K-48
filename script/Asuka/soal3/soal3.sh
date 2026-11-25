#!/bin/sh
# Soal 3 - routing statis router Asuka
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.117
ip route replace 192.235.3.128/26 via 192.235.4.154   # Kensuke
ip route replace 192.235.4.48/29 via 192.235.4.158   # Ritsuko
