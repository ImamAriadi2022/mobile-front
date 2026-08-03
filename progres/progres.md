# Progress Proyek Redesign ParkFinder

## Selesai

- **Integrasi Backend Live untuk Status Tiket & Parkir Aktif di Beranda (`HomeWidget`)**:
  - Mengonfigurasi `_checkActiveTicket()` di [home_widget.dart](file:///c:/programming/mobile-front/lib/features/home/widgets/home_widget.dart) untuk mengambil data tiket aktif (`/access/activeTicket`) dan reservasi aktif (`/users/{userId}/reservations` atau `/reservations`) secara langsung dari server backend live.
  - Memastikan banner "Parkir Aktif" di halaman utama langsung diperbarui ketika pengguna membooking slot, melakukan scan tiket QR, atau saat aplikasi dibuka kembali.
- **Integrasi Statistik Profil (Total Parkir & Parkir Aktif) dengan Live Backend**:
  - Mengonfigurasi kartu statistik pada [profil_widget.dart](file:///c:/programming/mobile-front/lib/features/profile/widgets/profil_widget.dart) dan [stats_card_widget.dart](file:///c:/programming/mobile-front/lib/features/profile/widgets/stats_card_widget.dart) agar menghitung nilai secara dinamis dari API REST backend (`HistoryService.getHistory(userId)`) serta data penyimpanan lokal aktif.
  - `Total Parkir`: Dihitung dari akumulasi total riwayat reservasi pengguna dari server backend.
  - `Parkir Aktif`: Dihitung dari jumlah sesi yang berstatus aktif (`active`, `pending`, `arrived`, `booked`, `claimed`) dari backend & penyimpanan lokal.
- **Integrasi Backend Live untuk Status Parkir Aktif**:
  - Menyelesaikan masalah koneksi halaman Status Parkir Aktif ([status_kendaraan_page.dart](file:///c:/programming/mobile-front/lib/features/home/pages/status_kendaraan_page.dart)) dan banner Parkir Aktif di [home_widget.dart](file:///c:/programming/mobile-front/lib/features/home/widgets/home_widget.dart).
  - Menambahkan *parsing* fleksibel dan pencocokan *case-insensitive* untuk status reservasi (`active`, `pending`, `arrived`, `booked`, `claimed`) dari response REST API.
  - Memperbaiki penanganan kunci JSON alternatif (`reservationId`/`id`/`_id`, `userId`/`id`, `slotName`/`slotNumber`) pada [booking_service.dart](file:///c:/programming/mobile-front/lib/features/parking/services/booking_service.dart), [history_service.dart](file:///c:/programming/mobile-front/lib/features/history/services/history_service.dart), [profile_data.dart](file:///c:/programming/mobile-front/lib/features/profile/models/profile_data.dart), dan [reservation_history.dart](file:///c:/programming/mobile-front/lib/features/history/models/reservation_history.dart).
  - Memastikan reservasi aktif yang tersimpan tidak terhapus secara tidak sengaja saat sinkronisasi background.
- **Build Rilis & Ekspor PWA ke Direktori `pwa/`**:
  - Aplikasi berhasil di-compile ke Web PWA rilis (`flutter build web --release`).
  - Hasil bundle rilis (`index.html`, `main.dart.js`, `manifest.json`, `flutter_service_worker.js`, `canvaskit/`, dan `assets/`) telah disalin ke direktori `pwa/` untuk pengujian langsung di Android / Browser.
- **Import Aset Foto Real dari `cdn-example` (Bukan Template/Dummy Lagi)**:
  - Mengimpor dan mengonfigurasi seluruh foto real dari sampel CDN (`cdn-example/`) ke dalam `lib/assets/` aplikasi.
  - Foto Gedung Real: `elektro.png`, `mastek.png`, `mbk.png` kini dipetakan secara dinamis pada kartu gedung di `HomeWidget` dan `BookingWidget`.
  - Foto Denah Parkir Real: `denah.png` / `denah_parkir.png` kini digunakan pada petunjuk area dan slot parkir.
  - Foto Onboarding Real: `gedung-wellcome.png` / `gedung_welcome.png` digunakan pada slide onboarding dan latar transisi.
  - Foto Mobil & Area Parkir Real: `mobil.png` dan `dashboard_parkir.png` / `status_parkir_aktif.png` digunakan pada hero banner, status kendaraan aktif, dan kartu status.
- **Pendokumentasian Rute CDN Bucket (`bucket.md`)**:
  - Membuat dokumen resmi [bucket.md](file:///c:/programming/mobile-front/bucket.md) dan [api-docs/bucket.md](file:///c:/programming/mobile-front/api-docs/bucket.md) yang merinci seluruh endpoint aset gambar Google Cloud Storage CDN Bucket (`https://storage.googleapis.com/parkfinderbucket`).
  - Berisi pemetaan rute aset gambar logo, latar belakang (background), onboarding, dashboard parkir, peta denah slot, QR scanner, serta foto profil pengguna.
- **Penggunaan Google Cloud Storage Bucket CDN untuk Seluruh Gambar**:
  - Mengonfigurasi seluruh pemuatan gambar dalam aplikasi menggunakan `Image.network` yang mengacu ke `AppConfig.storageUrl` (`https://storage.googleapis.com/parkfinderbucket`).
  - Dilengkapi *fallback errorBuilder* otomatis ke aset lokal real dari `cdn-example`.
- **Penghapusan Total Seluruh Data & Berkas Mock**:
  - Menghapus berkas simulasi offline `mock_data.dart`, `mock_response.dart`, dan `mock_router.dart`.
- **Integrasi Full Real REST API Live Backend**:
  - Aplikasi 100% berkomunikasi langsung dengan server backend Google Cloud Run (`https://backend-api-services-173368161554.asia-southeast2.run.app`).
  - Lulus verifikasi analisis kode Flutter (0 error & 0 warning).
- **Penerjemahan 100% Copywriting ke Bahasa Indonesia**:
  - Seluruh label navigasi dan antarmuka menggunakan Bahasa Indonesia baku & profesional.
- **Floating Tutorial Button "?"**:
  - Modal panduan 4 langkah penggunaan aplikasi di pojok kanan bawah.

## Sedang dikerjakan

- Pengujian PWA pada perangkat mobile Android.

## Tersisa

- Tidak ada (seluruh tugas utama telah diselesaikan).
