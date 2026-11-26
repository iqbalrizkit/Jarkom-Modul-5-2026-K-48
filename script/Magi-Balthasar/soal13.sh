#!/bin/sh
ALLOW="192.235.4.58 192.235.4.66 192.235.4.67 192.235.4.68 192.235.3.130"
iptables -N BRANKAS 2>/dev/null || iptables -F BRANKAS
for ip in $ALLOW; do iptables -A BRANKAS -s $ip -j ACCEPT; done
iptables -A BRANKAS -p tcp -j REJECT --reject-with tcp-reset
iptables -D INPUT -p tcp -m multiport --dports 5000,5001 -j BRANKAS 2>/dev/null
iptables -I INPUT 1 -p tcp -m multiport --dports 5000,5001 -j BRANKAS