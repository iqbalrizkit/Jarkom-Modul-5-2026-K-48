#!/bin/sh
iptables -t nat -D PREROUTING -i eth0 -s 192.235.4.58 -d 192.235.4.82 -p tcp -j DNAT --to-destination 192.235.3.194 2>/dev/null
iptables -t nat -A PREROUTING -i eth0 -s 192.235.4.58 -d 192.235.4.82 -p tcp -j DNAT --to-destination 192.235.3.194