# Progress Proyek Redesign ParkFinder

## Selesai

- **Penyesuaian Alur Tutorial & Onboarding**: Menghapus transisi tutorial lama yang berlebihan; alur dipusatkan sepenuhnya melalui Onboarding (`WelcomeWidget`) setelah login/register berhasil (`Splash` $\rightarrow$ `Login` $\rightarrow$ `Onboarding` $\rightarrow$ `Home`).
- **Redesign Halaman Beranda (Home)**: Menyesuaikan 100% dengan `Dashboard Parkir.png` (UserHeaderWidget `Beranda` dengan ikon sakelar tema, search bar `Cari Gedung Parkir`, banner card `Parkir Aktif` deep navy blue dengan tombol orange `Tampilkan QR`, dan daftar kartu `Gedung Parkir` lengkap dengan badge `TERSEDIA`/`PENUH`).
- **Redesign Area Parkir & Denah Slot**:
  - `BookingWidget` disesuaikan 100% dengan `Denah.png` (Cari Lokasi Parkir, pills filter `Semua`, `Terdekat`, `Populer`, `Baru`, dan daftar kartu lokasi parkir).
  - `DetailBookingWidget` & `ParkingSlotItemWidget` disesuaikan 100% dengan `Peta Parkir FT Unila.png` (Header `Peta Parkir`, kotak legenda status, indikator slot `12/20`, denah slot 2 kolom dengan penanda arah MASUK/KELUAR, dan banner konfirmasi slot pilihan).
- **Implementasi Dark & Light Mode Toggle After Login**:
  - Menambahkan ikon sakelar tema (Matahari / Bulan) pada `UserHeaderWidget` yang hadir di semua halaman pasca-login (`Home`, `Area`, `Status`, `Riwayat`, `Profil`).
  - Pengguna dapat beralih tema kapan saja dengan satu sentuhan.
- **Perbaikan Kontras Warna & Masalah Teks Putih di Background Putih**:
  - Memperbarui `app_colors.dart`, `stats_card_widget.dart`, `history_card_widget.dart`, `parking_slot_item_widget.dart`, `status_kendaraan_page.dart`, `history_widget.dart`, dan `profil_widget.dart` agar warna teks dan background menyesuaikan secara dinamis sesuai `Brightness` (Light/Dark Mode).
  - Mengeliminasi seluruh teks putih di atas latar belakang putih di Halaman Parkir, Status, Riwayat, dan Profil.
- **Batasan Tipe Kendaraan (Hanya Mobil)**:
  - Membatasi seluruh input, formulir tambah/edit, dan tampilan kendaraan hanya untuk jenis **Mobil** (menghapus opsi motor/tipe lain sesuai permintaan).
- Redesign presisi Halaman Masuk (`login_widget.dart`) & Halaman Daftar (`register_widget.dart`).
- Dokumentasi audit UI di `docs/ui_redesign_audit.md`.

## Sedang dikerjakan

- Review manual kode akhir.

## Tersisa

- Verifikasi visual runtime saat Flutter SDK tersedia di environment eksekusi.
