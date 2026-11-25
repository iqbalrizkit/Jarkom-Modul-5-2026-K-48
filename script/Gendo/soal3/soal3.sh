#!/bin/sh
# Soal 3 - routing statis router Gendo
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace 192.235.0.0/23 via 192.235.4.110   # Yui
ip route replace 192.235.2.0/24 via 192.235.4.114   # Hikari
ip route replace 192.235.3.0/25 via 192.235.4.110   # Yui
ip route replace 192.235.3.128/26 via 192.235.4.118   # Asuka
ip route replace 192.235.3.192/27 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.3.224/27 via 192.235.4.114   # Hikari
ip route replace 192.235.4.0/27 via 192.235.4.110   # Yui
ip route replace 192.235.4.32/28 via 192.235.4.110   # Yui
ip route replace 192.235.4.48/29 via 192.235.4.118   # Asuka
ip route replace 192.235.4.56/29 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.64/29 via 192.235.4.126   # Misato
ip route replace 192.235.4.72/29 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.80/28 via 192.235.4.130   # Shigeru
ip route replace 192.235.4.96/30 via 192.235.4.118   # Asuka
ip route replace 192.235.4.100/30 via 192.235.4.122   # Kaji
ip route replace 192.235.4.136/29 via 192.235.4.110   # Yui
ip route replace 192.235.4.144/30 via 192.235.4.110   # Yui
ip route replace 192.235.4.148/30 via 192.235.4.114   # Hikari
ip route replace 192.235.4.152/29 via 192.235.4.118   # Asuka
ip route replace 192.235.4.160/30 via 192.235.4.130   # Shigeru
ip route replace 192.235.4.164/30 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.168/30 via 192.235.4.134   # Fuyutsuki
