# Progress Proyek Redesign ParkFinder

## Selesai

- **Pendokumentasian Rute CDN Bucket (`bucket.md`)**:
  - Membuat dokumen resmi [bucket.md](file:///c:/programming/mobile-front/bucket.md) dan [api-docs/bucket.md](file:///c:/programming/mobile-front/api-docs/bucket.md) yang merinci seluruh endpoint aset gambar Google Cloud Storage CDN Bucket (`https://storage.googleapis.com/parkfinderbucket`).
  - Berisi pemetaan rute aset gambar logo, latar belakang (background), onboarding, dashboard parkir, peta denah slot, QR scanner, serta foto profil pengguna.
- **Penggunaan Google Cloud Storage Bucket CDN untuk Seluruh Gambar**:
  - Mengonfigurasi seluruh pemuatan gambar dalam aplikasi menggunakan `Image.network` yang mengacu ke `AppConfig.storageUrl` (`https://storage.googleapis.com/parkfinderbucket`).
  - Dilengkapi *fallback errorBuilder* otomatis ke aset lokal & ikon universal.
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

- Menunggu instruksi rilis/ekspor PWA dari pengguna.

## Tersisa

- Ekspor build rilis PWA ke direktori `pwa/` apabila diperintahkan oleh pengguna.
