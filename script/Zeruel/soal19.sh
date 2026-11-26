#!/bin/sh
command -v iptables >/dev/null || apk add --no-cache iptables
iptables -D INPUT -s 192.235.4.83 -j DROP 2>/dev/null;  iptables -I INPUT 1 -s 192.235.4.83 -j DROP
iptables -D OUTPUT -d 192.235.4.83 -j DROP 2>/dev/null; iptables -I OUTPUT 1 -d 192.235.4.83 -j DROP