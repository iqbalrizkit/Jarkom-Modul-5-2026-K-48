
# ---- Soal 5: kunci pintu NAT1 (policy DROP + pengecualian) ----
# Bersihkan aturan lama supaya script bisa dijalankan ulang.
iptables -F INPUT
iptables -F FORWARD
iptables -F OUTPUT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback tetap hidup.
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# (a) Balasan koneksi yang sudah ada / terkait.
iptables -A INPUT   -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# DHCP client Gendo ke NAT1 tetap jalan (port 67/68, tanpa IP NAT1).
iptables -A INPUT  -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp --sport 68 --dport 67 -j ACCEPT

# (d) Traffic dari prefix internal ke Gendo sendiri.
iptables -A INPUT  -s 192.235.0.0/16 -j ACCEPT

# (b) Traffic internal keluar internet lewat interface NAT1.
iptables -A FORWARD -s 192.235.0.0/16 -o "$NAT_IF" -j ACCEPT

# (c) Traffic antar-LAN tetap memakai alamat asli.
iptables -A FORWARD -s 192.235.0.0/16 -d 192.235.0.0/16 -j ACCEPT

# Koneksi baru dari sisi NAT1 tidak ada aturan ACCEPT -> kena policy DROP.
echo "Firewall aktif: INPUT/FORWARD DROP, NAT via $NAT_IF"
