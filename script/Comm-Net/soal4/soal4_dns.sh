#!/bin/sh
# Soal 4 - resolver DNS untuk node yang akan memasang paket.
# Memakai resolver publik agar tidak bergantung pada IP NAT1.
cat > /etc/resolv.conf <<'EOF'
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
