# 2. Strategi Idempotensi pada Konfirmasi Pembayaran
* **Status:** Accepted

## Konteks: 
Proses konfirmasi dan pembayaran (POST /reservations/{holdId}/confirm) rentan terhadap pemanggilan ganda akibat timeout jaringan atau aksi pengulangan (retry) oleh pengguna.

## Opsi yang Dipertimbangkan:
1. Penanganan Idempotency hanya di tingkat basis data (Unique Constraint).
2. Distributed Idempotency Layer menggunakan Redis Cache dengan Header Idempotency-Key.

## Keputusan: 
Menerapkan Redis-backed Idempotency Key Filter wajib menggunakan header Idempotency-Key (UUIDv4).

## Konsekuensi & Trade-off:
* **Kelebihan:** Menghentikan request duplikat langsung di entry point sebelum memicu proses transaksi atau pemanggilan payment gateway, serta menjamin transaksi diproses tepat satu kali (exactly-once execution).
* **Kekurangan:** Membutuhkan alokasi memori tambahan di Redis untuk menyimpan status dan respons sementara (response caching) sesuai durasi TTL Idempotency Key.