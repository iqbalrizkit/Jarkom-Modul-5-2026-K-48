#!/bin/sh
iptables -N SCAN 2>/dev/null || iptables -F SCAN
iptables -A SCAN -j LOG --log-prefix "SCAN-NERV: "
iptables -A SCAN -p tcp -j REJECT --reject-with tcp-reset
iptables -D INPUT -s 192.235.4.51 -p tcp --syn -m multiport --dports 22,23,3306 -j SCAN 2>/dev/null
iptables -I INPUT 1 -s 192.235.4.51 -p tcp --syn -m multiport --dports 22,23,3306 -j SCAN