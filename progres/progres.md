# Progress Proyek Redesign ParkFinder

## Selesai

- **Penjelasan Struktur & Pemetaan Aset Gambar PNG (`lib/assets/`)**:
  - Menyediakan tabel panduan pemetaan lengkap antara berkas PNG di `lib/assets/` dengan layar/widget pada antarmuka frontend aplikasi.
- **Implementasi Tombol Floating Tutorial "?" di Pojok Kanan Bawah**:
  - Membuat `FloatingTutorialWidget` (`lib/shared/widgets/floating_tutorial_widget.dart`) berupa tombol lingkaran melayang bertanda logo `?` di pojok kanan bawah pada seluruh halaman utama (`Beranda`, `Area Parkir`, `Status Parkir`, `Riwayat`, `Profil`).
  - Mengetuk tombol tersebut akan membuka Bottom Sheet Modal **"Panduan Penggunaan"** interaktif yang menjelaskan 4 langkah praktis menggunakan aplikasi ParkFinder FT Unila.
- **Penerjemahan 100% Copywriting ke Bahasa Indonesia**:
  - Mengubah seluruh label navigasi pada [bottom_nav_bar.dart](file:///c:/programming/mobile-front/lib/shared/widgets/bottom_nav_bar.dart):
    - `Home` $\rightarrow$ **`Beranda`**
    - `Area` $\rightarrow$ **`Area Parkir`**
    - `Parking` $\rightarrow$ **`Status Parkir`**
    - `History` $\rightarrow$ **`Riwayat`**
    - `Profile` $\rightarrow$ **`Profil`**
- **Re-build & Ekspor PWA**: Berhasil mengompilasi ulang Flutter PWA (`flutter build web --release`) dan memperbarui seluruh berkas di direktori root `pwa/`.
- Redesign presisi Halaman Masuk (`login_widget.dart`), Halaman Daftar (`register_widget.dart`), Beranda (Home), Area Parkir, Status Kendaraan, Riwayat, dan Profil.

## Sedang dikerjakan

- Selesai.

## Tersisa

- Tidak ada.
