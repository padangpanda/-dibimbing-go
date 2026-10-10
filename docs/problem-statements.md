# Problem Statement

Platform flash sale tiket TiketKilat menghadapi lonjakan trafik ekstrem (puluhan ribu request per detik) dalam durasi singkat saat penjualan dibuka. Tanpa mekanisme kendali konkurensi yang tepat, kondisi race condition dapat menyebabkan overselling (satu kursi terjual ke lebih dari satu pengguna). Di sisi lain, penggunaan penguncian tradisional (pessimistic locking) langsung pada database relasional berisiko memicu bottleneck, connection pool exhaustion, dan latency spike. Sistem membutuhkan mekanisme reservasi sementara (hold) yang terdistribusi, pelepasan status otomatis saat batas waktu kedaluwarsa habis, serta jaminan idempotency transaksi pembayaran agar performa tetap cepat dan tepat (correct) walau dijalankan di banyak instance.

## Pertanyaan Bisnis & Teknis Utama

* **Kinerja Konkurensi:** Berapa rasio alokasi tiket berhasil vs. gagal yang dapat ditangani sistem pada kondisi lonjakan trafik tinggi tanpa penurunan responsivitas?

* **Pencegahan Overselling:** Bagaimana menjamin alokasi exactly-once pada setiap kursi di tengah eksekusi paralel pada banyak instance aplikasi?

* **Efisien & Responsif:** Bagaimana memastikan alur hold-then-confirm tidak membebani database utama saat lonjakan terjadi?

* **Ketahanan Operasional:** Bagaimana menjamin eksekusi pembayaran bersifat idempotent jika terjadi retry jaringan atau duplicate request dari klien?