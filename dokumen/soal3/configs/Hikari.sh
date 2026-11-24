#!/bin/sh
# Soal 3 - routing statis router Hikari
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace default via 192.235.4.113
ip route replace 192.235.3.224/27 via 192.235.4.150   # Kaworu
