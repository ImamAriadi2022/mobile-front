# Progres Project ParkFinder — Mobile App & PWA

## Ringkasan Progres
Berikut adalah status fitur dan perbaikan pada aplikasi mobile ParkFinder.

### Fitur yang Sudah Selesai / Diperbaiki (Selesai ✅)
- **Splash & Welcome Flow** (`/`, `/welcome`, `/welcome-transition`)
- **Autentikasi & Registrasi** (`/login`, `/register` - Dibatasi khusus role `user`)
- **Booking & Reservasi Slot** (`/booking`, `/detail-booking` - Terintegrasi API `/areas` & `/reservations`)
- **Profil & Pengaturan** (`/profil`, `/pengaturan`)
- **Deteksi Tiket Hasil Scan (Task 0042)**: Masalah deteksi tiket aktif di Home & dialog booking telah diperbaiki.
- **PWA Build**: PWA build berhasil di-compile ke folder `pwa/`.

### Fitur yang Perlu Perbaikan / Belum Selesai (Perlu Perbaikan ⚠️)
1. **`/animasi-scan` (AnimasiScanPage)**: Data statis (3 item hardcoded).
2. **`/halaman-scan` (HalamanScanPage)**: Penyelarasan API `POST /access/verify` (backend menerima `qrCode`, mobile mengirim `ticketId`).
3. **`/scan-berhasil` (ScanBerhasilPage)**: Ticket code masih hardcoded, belum mengambil hasil scan asli.
4. **`/home` (HomePage)**: Daftar parkir terdekat masih menggunakan 3 item dummy/hardcoded.
5. **`/status-kendaraan` (StatusKendaraanPage)**: Elapsed timer parkir aktif belum berjalan (stuck).
6. **`/history` (HistoryPage)**: Riwayat booking masih dummy/hardcoded (8 item).
7. **`/edit-profil` (EditProfilPage)**: Form edit belum melakukan hit ke API untuk menyimpan data (hanya `Navigator.pop`).

### Sisa Pekerjaan untuk Selesai (ToDo List)
- [ ] Hubungkan riwayat booking di `/history` dengan API.
- [ ] Aktifkan timer di `/status-kendaraan` agar berjalan dinamis (incrementing).
- [ ] Ganti dummy data daftar parkir di `/home` dengan data real dari API `/areas`.
- [ ] Perbaiki alur verifikasi scanner `/halaman-scan` agar sinkron dengan API backend (`qrCode` vs `ticketId`).
- [ ] Hubungkan form `/edit-profil` dengan endpoint update profile di backend.
