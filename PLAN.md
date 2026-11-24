# Rencana Pengerjaan Modul 5 — Operation Geofront (K-48)

## 0. Status & temuan awal

- PDF soal berhasil diekstrak (14 halaman) dan topologi `topo_5.png` berhasil diambil dari halaman 4.
- GNS3 controller: `http://10.4.89.250:3080`, versi **3.0.6** (API v3, JWT).
- Library `gns3api` (repo `manoedinata/gns3api-py`, mendukung GNS3 3.0.6) sudah terpasang di
  `.venv_gns3` dan berhasil login + list project.
- Project `K-48-MODUL-5` (`36e5ac5a-5ae2-442b-b9c3-fe64af4e3336`) status **opened** tetapi
  **masih kosong (0 node)** → seluruh topologi dibangun dari nol pada soal 2.
- Template yang tersedia: `alpinet` (ardhptr21/alpinet:latest), `debinet`
  (ardhptr21/debinet:latest), `NAT`, `Ethernet switch`. Image docker default 4 adapter,
  jadi **Gendo harus dibuat dengan ≥9 adapter** (7 link router + NAT1 + LAN Cmd).

## 1. Topologi yang sudah diverifikasi dari gambar

Pohon router (17 router, 16 link):

```
Gendo
├── Yui ──────── Rei (Quarters), Shinji (Garden), Mari (Dock)
├── Hikari ───── Kaworu (Relay)
├── Asuka ────── Kensuke (Bunker), Ritsuko (Lab)
├── Kaji        (Intel)
├── Misato      (Cage)
├── Shigeru ──── Makoto (Radar)
└── Fuyutsuki ── Maya (Medic), Toji (Dogma)
```

LAN tiap router (switch → gateway):

| Router | Switch | Container (jumlah host) | Total host |
|---|---|---|---|
| Rei | Switch-Quarters | Quarters 500 | 500 |
| Hikari | Switch-Comm | Comm-Net 200 | 200 |
| Yui | Switch-Hangar | Hangar-Crew 100 | 100 |
| Kensuke | Switch-Bunker | Sachiel 55 | 55 |
| Maya | Switch-Medic | Pen-Pen 1, Medic-Bay 25 | 26 |
| Kaworu | Switch-Relay | Relay-Node 25 | 25 |
| Shinji | Switch-Garden | Garden-Staff 14 | 14 |
| Mari | Switch-Dock | Dock-Crew 12 | 12 |
| Ritsuko | Switch-Lab | Entry-Plug 3, Dummy-Plug 2 | 5 |
| Fuyutsuki | Switch-Terminal | Casper 1, Balthasar 1, Melchior 1 | 3 |
| Misato | Switch-Cage | Unit-01/02/00 @1 | 3 |
| Toji | Switch-Dogma | Lilith 1, Adam 1 | 2 |
| Shigeru | Switch-Monolith | Zeruel 1, Armisael 1 | 2 |
| Makoto | Switch-Radar | Radar-Array 4 | 4 |
| Asuka | Switch-Archive | Archive-Vault 1 | 1 |
| Kaji | Switch-Intel | Spy 1 | 1 |
| Gendo | Switch-Cmd | Tokyo3-Core 1 | 1 |

## 2. Soal 1 — VLSM

### 2.1 Aturan hitung

- Kebutuhan usable satu LAN = **jumlah host + 1 gateway** (gateway = IP usable pertama).
- Prefix terkecil yang muat: `2^(32-p) - 2 >= host + 1`.
- Link router–router = 2 IP → **/30**.
- Urutan: blok terbesar dulu; jika ukuran sama → **LAN dulu**, lalu **urutan tabel**.
- Host di satu switch diberi IP usable berurutan sesuai urutan nama kiri→kanan
  (Medic: Pen-Pen lalu Medic-Bay; Lab: Entry-Plug lalu Dummy-Plug; Terminal: Casper,
  Balthasar, Melchior; Cage: Unit-01, Unit-02, Unit-00; Dogma: Lilith, Adam;
  Monolith: Zeruel, Armisael).

### 2.2 Ukuran blok

| Kebutuhan host+gw | Prefix | Usable |
|---|---|---|
| 501 | /23 | 510 |
| 201 | /24 | 254 |
| 101 | /25 | 126 |
| 56 | /26 | 62 |
| 27 (Medic), 26 (Relay), 15 (Garden) | /27 | 30 |
| 13 (Dock) | /28 | 14 |
| 6 (Lab), 4 (Terminal), 4 (Cage), 3 (Dogma), 3 (Monolith), 5 (Radar) | /29 | 6 |
| 2 (Archive/Intel/Cmd) | /30 | 2 |
| 16 link | /30 | 2 |

Total kebutuhan = **1.196 alamat** → prefix kelompok minimal **/21**. Jika prefix yang
diberikan /16, sisa sangat banyak.

### 2.3 Tabel & alokasi

Tabel lengkap dihasilkan otomatis:

```bash
python3 vlsm.py 192.235.0.0/16 --json vlsm_plan.json --md vlsm_table.md
```

(contoh memakai /16; ganti argumen dengan prefix kelompok yang sebenarnya, semua alamat
bergeser otomatis dengan offset yang sama).

Contoh hasil untuk `192.235.0.0/16`:

- Quarters `/23` 192.235.0.0, gw .0.1
- Comm `/24` 192.235.2.0, gw .2.1
- Hangar `/25` 192.235.3.0, gw .3.1
- Bunker `/26` 192.235.3.128, gw .3.129
- Medic `/27` 192.235.3.192, Relay `/27` 192.235.3.224, Garden `/27` 192.235.4.0
- Dock `/28` 192.235.4.32
- Lab `/29` .4.48, Terminal .4.56, Cage .4.64, Dogma .4.72, Monolith .4.80, Radar .4.88
- Archive `/30` .4.96, Intel .4.100, Cmd .4.104
- 16 link `/30` mulai .4.108 s/d .4.171

### 2.4 Pohon IP & jalur Dummy-Plug → Armisael

Jalur: **Dummy-Plug → Switch-Lab → Ritsuko → Asuka → Gendo → Shigeru → Switch-Monolith →
Armisael**. Subnet yang dilingkari di pohon IP:

1. `Switch-Lab` (`/29`, 192.235.4.48)
2. link `Asuka–Ritsuko` (`/30`, 192.235.4.156)
3. link `Gendo–Asuka` (`/30`, 192.235.4.116)
4. link `Gendo–Shigeru` (`/30`, 192.235.4.128)
5. `Switch-Monolith` (`/29`, 192.235.4.80)

### 2.5 Deliverable soal 1

- [x] Tabel VLSM (network, prefix, gateway, broadcast, jumlah IP terpakai, sisa).
- [x] Tabel alamat tiap container (nama, IP, gateway).
- [x] Gambar pohon IP (binary prefix tree) dengan 5 subnet jalur Dummy-Plug–Armisael dilingkari.
- [x] Penjelasan hitungan satu subnet di laporan (contoh: Quarters 500 host → 501 → 2^9=512
      → /23, network .0.0, gateway .0.1, broadcast .1.255, sisa 9).

Output: `soal1/` (lihat `soal1/README.md`).


## 3. Setelah soal 1 (soal 2, ringkas)

1. Buat 17 router container (alpinet/debinet) + 17 Ethernet switch + 25 host container + NAT1.
   Gendo butuh 9 adapter.
2. Sambungkan sesuai pohon di atas; **Gendo–NAT1**, dan tiap router–switch LAN.
3. Beri IP semua interface router sesuai `vlsm_plan.json`; gateway LAN = IP `.1`.
   Link: sisi parent `.1`, sisi child `.2`.
4. Aktifkan `net.ipv4.ip_forward=1` di semua router.
5. Gendo: interface ke NAT1 pakai DHCP.
6. Verifikasi: `ip -br a` tiap router + ping dua ujung tiap link.

Status soal 2: **selesai**. 60 node, 59 link, 16/16 ping link OK,
17/17 `ip_forward=1`, Gendo DHCP dari NAT1. Lihat `soal2/README.md`.

## 3b. Soal 3 — routing statis (selesai)

- Non-Gendo: `default via induk` + rute subnet bawahan (ringkas jika tepat).
- Gendo: 22 rute + default DHCP NAT1. Total 31 rute statis subnet.
- IP sementara: Armisael, Lilith, Sachiel, Comm-Net.
- Armisael ping Lilith/Sachiel/Comm-Net → 3/3 sukses, 0% loss.
- Bukti screenshot asli: `soal3/bukti/` (12 file), laporan: `soal3/LAPORAN_SOAL3.md`.

## 3c. Soal 4 — internet, NAT, DNS (selesai)

- `/root/gendo.sh` berisi konfigurasi soal 2 + 3 + 4 (idempoten).
- NAT: MASQUERADE hanya untuk `192.235.0.0/16` yang keluar lewat interface
  default route; tidak ada IP NAT1 yang ditulis → tahan perubahan IP NAT1.
- Antar-LAN tidak di-NAT (counter rule tetap 0), internet menaikkan counter.
- DNS `8.8.8.8`/`1.1.1.1` di 25 host; 3 node Magi dapat IP sementara & resolve.
- Armisael & Lilith ping `8.8.8.8` dan `deb.debian.org` → 4/4, 0% loss.
- Bukti screenshot asli: `soal4/bukti/` (8 file), laporan: `soal4/LAPORAN_SOAL4.md`.

## 3d. Soal 5 — firewall Gendo (selesai)

- `INPUT`/`FORWARD` policy DROP, `OUTPUT` ACCEPT; semua pengecualian tertulis di
  `/root/gendo.sh` bersama konfigurasi soal 2-4.
- Diizinkan: loopback, established/related, internal→internet, antar-LAN,
  internal→Gendo, DHCP UDP 67/68. Tidak ada ACCEPT untuk sumber NAT1.
- DHCP ulang pasca-firewall OK; Armisael & Lilith ping `8.8.8.8` OK;
  Soal 2-4 tetap lolos verifikasi.
- Bukti screenshot asli: `soal5/bukti/` (8 file), laporan: `soal5/LAPORAN_SOAL5.md`.

## 3e. Soal 6 — IP permanen host (selesai)

- 25/25 node non-router: IP statis + gateway sesuai VLSM; `ip -br` cocok.
- Ping gateway 25/25 OK; Unit-01 → `192.235.4.65` 4/4, 0% loss.
- Persistensi via `/root/init.sh` (dipanggil init script image saat restart).
- Uji restart 25/25 host berhasil; Soal 3/4/5 tetap lolos.
- Bukti screenshot asli: `soal6/bukti/` (8 file), laporan: `soal6/LAPORAN_SOAL6.md`.

## 3f. Soal 7 — MAGI aktif (selesai)

- `iptables` + `netcat-traditional` dipasang di Casper/Balthasar/Melchior lewat
  `/root/<nama>.sh`; listener sesuai glosarium (Casper 5000, Balthasar 5000+5001,
  Melchior 5000).
- Lilith mengirim 4 pesan; 4/4 diterima dan ditampilkan di node tujuan.
- Bukti screenshot asli: `soal7/bukti/` (8 file), laporan: `soal7/LAPORAN_SOAL7.md`.

## 3g. Soal 8 — kondisi normal Pen-Pen & Tokyo3-Core (selesai)

- Listener `:80` di Pen-Pen/Tokyo3-Core dan `:8080` di Tokyo3-Core; jawaban
  `Welcome to <hostname>` dan `syifa imutz`.
- Lilith `nc` ke 3 port berhasil; port 22 refused dalam ±0.006 detik (RC=1).
- Skrip di `/root/Pen-Pen.sh` dan `/root/Tokyo3-Core.sh`.
- Bukti screenshot asli: `soal8/bukti/` (8 file), laporan: `soal8/LAPORAN_SOAL8.md`.

## 3h. Soal 9 — sabotase routing Shigeru (selesai)

- `break_routing.sh` dari asisten dijalankan di Shigeru tanpa dibaca isinya.
- 4 penyebab: `ip_forward=0`, default via Makoto, blackhole `192.235.4.72/29`,
  policy rule `iif eth0 lookup 100` + `unreachable default` table 100.
- Diperbaiki lewat `/root/soal9_fix.sh`; Lilith → Armisael 4/4, 0% loss.
- Bukti screenshot asli: `soal9/bukti/` (8 file), laporan: `soal9/LAPORAN_SOAL9.md`.

## 3i. Soal 10 — sabotase NAT Misato & Gendo (selesai)

- `break_nat.sh` dari asisten dijalankan di Misato dan Gendo tanpa dibaca isinya.
- 2 penyebab: SNAT Cage → `172.31.99.1` di Misato dan aturan `RETURN` untuk
  `192.235.4.64/29` di Gendo; Intel tidak terdampak karena lewat Kaji (tanpa SNAT).
- Diperbaiki lewat `/root/soal10_fix.sh`; Unit-01 → `8.8.8.8` 4/4.
- NAT sumber terjadi di **Gendo** (`POSTROUTING MASQUERADE -o eth1` / NAT1).
- Bukti screenshot asli: `soal10/bukti/` (12 file), laporan: `soal10/LAPORAN_SOAL10.md`.

## 4. Keputusan yang masih dibutuhkan

- **Prefix kelompok yang pasti** (contoh `192.235.136.0/21`). Saat ini tabel memakai
  `192.235.0.0/16` sebagai placeholder. Kirim prefix lengkap → tabel, JSON, dan script
  build langsung diregenerasi.
- Image host sudah diputuskan: **Magi-\* memakai `debinet`** (apt tersedia untuk soal 4/7/12),
  host lain `alpinet`. DNS untuk pemasang paket sudah diselesaikan di soal 4.
- Penomoran interface docker (eth0, eth1, ...) mengikuti urutan link yang dibuat di GNS3;
  perlu dicatat saat build agar config tidak tertukar.
