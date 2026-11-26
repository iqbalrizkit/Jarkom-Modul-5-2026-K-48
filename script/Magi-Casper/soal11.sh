#!/bin/sh
iptables -D INPUT -p icmp --icmp-type echo-request -j DROP 2>/dev/null
iptables -I INPUT 1 -p icmp --icmp-type echo-request -j DROP