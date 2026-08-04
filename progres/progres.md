# Progress Proyek Redesign ParkFinder

## Selesai

- **Pemetaan Dinamis Nama & Detail Gedung pada Peta Parkir (Tanpa Hardcoded Dummy)**:
  - Menyelesaikan bug pemilihan gedung di [detail_booking_widget.dart](file:///c:/programming/mobile-front/lib/features/parking/widgets/detail_booking_widget.dart). Ketika pengguna mengeklik kartu gedung mana pun (misal *Mastek / Dekanat*, *MBK / Mesin*, *Gedung Elektro*, dsb.), halaman Detail Booking kini secara dinamis mencari dan me-render nama gedung (`_areaName`) dan lokasi alamat (`_areaAddress`) asli dari REST API backend (`BookingService.getAreas()`).
  - Menghapus teks dummy hardcoded *"Teknik elektro universitas lampung"* dan *"Gedung Teknik Elektro"* pada judul halaman, dialog konfirmasi reservasi slot, dan notifikasi header.
- **Pembersihan Total Sesi Parkir Hantu untuk Akun Baru & Pengalihan Keluar Parkir**:
  - Mengonfigurasi `login` di [auth_service.dart](file:///c:/programming/mobile-front/lib/features/auth/services/auth_service.dart) agar menghapus sisa data tiket/reservasi lokal (`ActiveTicketStorage` & `ActiveReservationStorage`) ketika pengguna baru melakukan login/registrasi.
  - Memperbarui [status_kendaraan_page.dart](file:///c:/programming/mobile-front/lib/features/home/pages/status_kendaraan_page.dart) agar tombol "Selesai Parkir" / "Keluar Parkir" selalu menghapus sesi parkir lokal secara aman, meskipun server memberikan respons 404/400 (karena sesi di backend sudah berakhir), sehingga pengguna tidak lagi tertahan dengan pesan error.
  - Menghapus pembuatan tiket dummy otomatis `TCK-8891234` di [scan_berhasil_widget.dart](file:///c:/programming/mobile-front/lib/features/scan/widgets/scan_berhasil_widget.dart).
- **Generasi QR Code Tiket Masuk Real & Dinamis**:
  - Mengonfigurasi `_showQrCodeDialog` pada [home_widget.dart](file:///c:/programming/mobile-front/lib/features/home/widgets/home_widget.dart) untuk me-render gambar QR Code yang di-generate secara real-time berdasarkan `ticketCode` / `reservationId` nyata milik pengguna dari REST API backend.
- **Integrasi Backend Live untuk Status Tiket & Parkir Aktif di Beranda (`HomeWidget`)**:
  - Mengonfigurasi `_checkActiveTicket()` di [home_widget.dart](file:///c:/programming/mobile-front/lib/features/home/widgets/home_widget.dart) untuk mengambil data tiket aktif (`/access/activeTicket`) dan reservasi aktif (`/users/{userId}/reservations` atau `/reservations`) secara langsung dari server backend live.
- **Integrasi Statistik Profil (Total Parkir & Parkir Aktif) dengan Live Backend**:
  - Mengonfigurasi kartu statistik pada [profil_widget.dart](file:///c:/programming/mobile-front/lib/features/profile/widgets/profil_widget.dart) dan [stats_card_widget.dart](file:///c:/programming/mobile-front/lib/features/profile/widgets/stats_card_widget.dart) agar menghitung nilai secara dinamis dari API REST backend (`HistoryService.getHistory(userId)`).
- **Build Rilis & Ekspor PWA ke Direktori `pwa/`**:
  - Aplikasi berhasil di-compile ke Web PWA rilis (`flutter build web --release`).
  - Hasil bundle rilis (`index.html`, `main.dart.js`, `manifest.json`, `flutter_service_worker.js`, `canvaskit/`, dan `assets/`) telah disalin ke direktori `pwa/` untuk pengujian langsung di Android / Browser.
- **Import Aset Foto Real dari `cdn-example` (Bukan Template/Dummy Lagi)**:
  - Mengimpor dan mengonfigurasi seluruh foto real dari sampel CDN (`cdn-example/`) ke dalam `lib/assets/` aplikasi.
- **Pendokumentasian Rute CDN Bucket (`bucket.md`)**:
  - Membuat dokumen resmi [bucket.md](file:///c:/programming/mobile-front/bucket.md) dan [api-docs/bucket.md](file:///c:/programming/mobile-front/api-docs/bucket.md).
- **Penggunaan Google Cloud Storage Bucket CDN untuk Seluruh Gambar**:
  - Mengonfigurasi seluruh pemuatan gambar dalam aplikasi menggunakan `Image.network` yang mengacu ke `AppConfig.storageUrl` (`https://storage.googleapis.com/parkfinderbucket`).
- **Penghapusan Total Seluruh Data & Berkas Mock**:
  - Menghapus berkas simulasi offline `mock_data.dart`, `mock_response.dart`, dan `mock_router.dart`.
- **Integrasi Full Real REST API Live Backend**:
  - Aplikasi 100% berkomunikasi langsung dengan server backend Google Cloud Run (`https://backend-api-services-173368161554.asia-southeast2.run.app`).
  - Lulus verifikasi analisis kode Flutter (0 error & 0 warning).

## Sedang dikerjakan

- Pengujian PWA pada perangkat mobile Android.

## Tersisa

- Tidak ada (seluruh tugas utama telah diselesaikan).
