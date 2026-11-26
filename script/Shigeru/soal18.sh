#!/bin/sh
iptables -N ZONA 2>/dev/null || iptables -F ZONA
iptables -A ZONA -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A ZONA -s 192.235.4.56/29 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A ZONA -j DROP
iptables -D FORWARD -i eth1 -j ZONA 2>/dev/null
iptables -A FORWARD -i eth1 -j ZONA