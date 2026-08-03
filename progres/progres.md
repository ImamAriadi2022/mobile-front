# Progress Proyek Redesign ParkFinder

## Selesai

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
