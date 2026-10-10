# 1. Strategi Concurrency & Locking untuk Reservasi Kursi
* **Status:** Accepted

## Konteks: 
Sistem perlu menangani reservasi kursi secara cepat dan mencegah overselling saat lonjakan trafik flash sale. Membawa seluruh lonjakan read/write langsung ke database utama (PostgreSQL) menggunakan SELECT FOR UPDATE akan menyebabkan kegagalan koneksi database.

## Opsi yang Dipertimbangkan:
1. Database Pessimistic Locking (SELECT FOR UPDATE)
2. Database Optimistic Locking (Versioning)
3. In-Memory Locking (Go sync.Mutex / Channel)
4. Distributed Atomic Lock / State via Redis (Lua Script)

## Keputusan: 
Menggunakan Redis Atomic Lua Script di layer cache sebagai garda utama penanganan hold kursi, dikombinasikan dengan Optimistic Locking / Transaction saat persistensi ke database PostgreSQL.

## Konsekuensi & Trade-off:
* **Kelebihan:** Kecepatan in-memory Redis mampu merespons lonjakan trafik dalam skala milidetik, mendukung skenario horizontal scaling karena lock/state dikelola secara terpusat di Redis Cluster, serta memproteksi database dari lonjakan beban langsung.
* **Kekurangan:** Membutuhkan sinkronisasi data yang konsisten antara Redis dan PostgreSQL, serta penanganan pembersihan state jika terjadi kegagalan jaringan (network partition).