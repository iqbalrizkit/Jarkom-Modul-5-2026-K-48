#!/bin/sh
# gendo.sh - konfigurasi lengkap Gendo (soal 2 + 3 + 4)
# Dijalankan ulang dengan aman (idempoten).

# ---- Soal 2: IP interface + DHCP NAT1 ----
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
ip link set lo up
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null
ip addr add 192.235.4.105/30 dev eth0
ip link set eth2 up
ip addr flush dev eth2 2>/dev/null
ip addr add 192.235.4.109/30 dev eth2
ip link set eth3 up
ip addr flush dev eth3 2>/dev/null
ip addr add 192.235.4.113/30 dev eth3
ip link set eth4 up
ip addr flush dev eth4 2>/dev/null
ip addr add 192.235.4.117/30 dev eth4
ip link set eth5 up
ip addr flush dev eth5 2>/dev/null
ip addr add 192.235.4.121/30 dev eth5
ip link set eth6 up
ip addr flush dev eth6 2>/dev/null
ip addr add 192.235.4.125/30 dev eth6
ip link set eth7 up
ip addr flush dev eth7 2>/dev/null
ip addr add 192.235.4.129/30 dev eth7
ip link set eth8 up
ip addr flush dev eth8 2>/dev/null
ip addr add 192.235.4.133/30 dev eth8
ip link set eth1 up
ip addr flush dev eth1 2>/dev/null
udhcpc -i eth1 -q -n -t 10 >/dev/null 2>&1 || true

# ---- Soal 3: routing statis ----
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace 192.235.0.0/23 via 192.235.4.110   # Yui
ip route replace 192.235.2.0/24 via 192.235.4.114   # Hikari
ip route replace 192.235.3.0/25 via 192.235.4.110   # Yui
ip route replace 192.235.3.128/26 via 192.235.4.118   # Asuka
ip route replace 192.235.3.192/27 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.3.224/27 via 192.235.4.114   # Hikari
ip route replace 192.235.4.0/27 via 192.235.4.110   # Yui
ip route replace 192.235.4.32/28 via 192.235.4.110   # Yui
ip route replace 192.235.4.48/29 via 192.235.4.118   # Asuka
ip route replace 192.235.4.56/29 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.64/29 via 192.235.4.126   # Misato
ip route replace 192.235.4.72/29 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.80/28 via 192.235.4.130   # Shigeru
ip route replace 192.235.4.96/30 via 192.235.4.118   # Asuka
ip route replace 192.235.4.100/30 via 192.235.4.122   # Kaji
ip route replace 192.235.4.136/29 via 192.235.4.110   # Yui
ip route replace 192.235.4.144/30 via 192.235.4.110   # Yui
ip route replace 192.235.4.148/30 via 192.235.4.114   # Hikari
ip route replace 192.235.4.152/29 via 192.235.4.118   # Asuka
ip route replace 192.235.4.160/30 via 192.235.4.130   # Shigeru
ip route replace 192.235.4.164/30 via 192.235.4.134   # Fuyutsuki
ip route replace 192.235.4.168/30 via 192.235.4.134   # Fuyutsuki

# ---- Soal 4: NAT / internet ----
# Soal 4 - akses internet seluruh jaringan lewat Gendo.
# Tidak ada IP NAT1 yang ditulis: interface yang dipakai dideteksi dari
# default route, sehingga konfigurasi tetap jalan jika IP NAT1 berganti.
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || \
  echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

NAT_IF=$(ip -4 route show default | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}')
[ -z "$NAT_IF" ] && NAT_IF=eth1

# Hanya sumber dari prefix internal yang diterjemahkan, dan hanya saat
# keluar lewat interface NAT1. Traffic antar-LAN lewat interface lain
# sehingga source address aslinya tetap dipertahankan.
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s 192.235.0.0/16 -o "$NAT_IF" -j MASQUERADE
echo "NAT aktif: 192.235.0.0/16 -> $NAT_IF"

