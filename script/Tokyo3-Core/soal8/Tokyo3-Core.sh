#!/bin/sh
# Soal 8 - kondisi normal Tokyo3-Core (belum disabotase)
pkill -f 'nc -l' 2>/dev/null || true
pkill -f 'nc -N -l' 2>/dev/null || true
start_listener() {
  port=$1
  text=$2
  nohup sh -c "while true; do printf '%s\n' \"$text\" | nc -N -l $port; done" >/dev/null 2>&1 &
}
start_listener 80 "Welcome to $(hostname)"
start_listener 8080 "syifa imutz"
sleep 2
ss -ltnp | grep -E ':80|:8080' || true
