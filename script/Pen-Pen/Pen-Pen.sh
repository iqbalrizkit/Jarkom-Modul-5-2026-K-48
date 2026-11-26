#!/bin/sh
# ===== JADWAL (UTC = WIB - 7) =====
PILOT_START=01:00     # 08.00 WIB
PILOT_STOP=09:00      # 16.00 WIB
PILOT_DAYS=Mon,Tue,Wed,Thu,Fri
STAF_START=10:00      # 17.00 WIB
STAF_STOP=16:00       # 23.00 WIB
# ==================================
PILOT="192.235.4.66 192.235.4.67 192.235.4.68 192.235.3.130"
STAF="192.235.4.74 192.235.4.75"
DUMMY="192.235.4.51 192.235.4.50 192.235.4.102"

command -v iptables >/dev/null || apk add --no-cache iptables

# listener port 80 (soal 8)
pkill -f pp80-loop 2>/dev/null
nohup sh -c ': pp80-loop; while true; do printf "Welcome to %s\n" "$(hostname)" | nc -N -l 80; done' >/dev/null 2>&1 &

# firewall jadwal
iptables -N PENPEN 2>/dev/null || iptables -F PENPEN
for ip in $DUMMY; do iptables -A PENPEN -s $ip -j DROP; done
for ip in $PILOT; do
  iptables -A PENPEN -s $ip -m time --timestart $PILOT_START --timestop $PILOT_STOP --weekdays $PILOT_DAYS -j ACCEPT
  iptables -A PENPEN -s $ip -j DROP
done
for ip in $STAF; do
  iptables -A PENPEN -s $ip -m time --timestart $STAF_START --timestop $STAF_STOP -j ACCEPT
  iptables -A PENPEN -s $ip -j DROP
done
iptables -D INPUT -p icmp --icmp-type echo-request -j PENPEN 2>/dev/null
iptables -D INPUT -p tcp --dport 80 -j PENPEN 2>/dev/null
iptables -I INPUT 1 -p icmp --icmp-type echo-request -j PENPEN
iptables -I INPUT 1 -p tcp --dport 80 -j PENPEN