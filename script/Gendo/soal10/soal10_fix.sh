#!/bin/sh
# Soal 10 - perbaikan NAT (dijalankan di Misato dan Gendo)
HOST=$(hostname)
if [ "$HOST" = "Misato" ]; then
  # Hapus SNAT yang salah: Cage tidak boleh diterjemahkan di router internal.
  iptables -t nat -D POSTROUTING -s 192.235.4.64/29 ! -d 192.235.0.0/16 \
    -o eth1 -j SNAT --to-source 172.31.99.1 2>/dev/null || true
  echo "Misato: SNAT 172.31.99.1 dihapus"
elif [ "$HOST" = "Gendo" ]; then
  # Hapus RETURN yang membuat Cage melewati MASQUERADE di router keluar.
  iptables -t nat -D POSTROUTING -s 192.235.4.64/29 -o eth1 -j RETURN 2>/dev/null || true
  echo "Gendo: RETURN untuk Cage dihapus"
else
  echo "Host tidak dikenal: $HOST" >&2
  exit 1
fi
iptables -t nat -S POSTROUTING
