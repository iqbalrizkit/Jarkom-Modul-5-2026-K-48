#!/bin/sh
A=192.235.4.83
iptables -D INPUT -s $A -j DROP 2>/dev/null;    iptables -I INPUT 1 -s $A -j DROP
iptables -D OUTPUT -d $A -j DROP 2>/dev/null;   iptables -I OUTPUT 1 -d $A -j DROP
iptables -D FORWARD -s $A -j DROP 2>/dev/null;  iptables -I FORWARD 1 -s $A -j DROP
iptables -D FORWARD -d $A -j DROP 2>/dev/null;  iptables -I FORWARD 1 -d $A -j DROP