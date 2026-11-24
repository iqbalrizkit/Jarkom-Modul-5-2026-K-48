#!/bin/sh
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
