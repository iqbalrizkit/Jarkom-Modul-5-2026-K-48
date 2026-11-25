#!/bin/sh
# Soal 7 - MAGI Magi-Casper: iptables + netcat-traditional + listener
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq iptables netcat-traditional
NC=$(command -v nc.traditional || command -v nc)
echo "netcat: $NC"
pkill -f 'nc.traditional -l' 2>/dev/null || true
pkill -f 'nc -l' 2>/dev/null || true
start_listener() {
  p=$1
  log=/root/magi_${p}.log
  : > "$log"
  nohup sh -c "while true; do $NC -l -p $p >> $log 2>&1; done" >/dev/null 2>&1 &
}
start_listener 5000
sleep 2
ss -ltnp | grep -E ':5000|:5001' || true
