# Progress Proyek Redesign ParkFinder

## Selesai

- Redesign presisi Halaman Masuk (`login_widget.dart`) mengacu 100% pada `Halaman Masuk.png`: Logo badge, judul Smart Parking FT, kartu putih rounded dengan shadow, field `Nama Pengguna/Email` & `Kata Sandi`, link `Lupa Sandi?`, tombol `MASUK` navy blue, link `Daftar Sekarang`, serta footer `Dikelola oleh ParkFinder Developer`.
- Redesign presisi Halaman Daftar (`register_widget.dart`) mengacu 100% pada `Halaman Daftar.png`: Judul `Daftar Akun`, kartu putih rounded, 6 field input lengkap dengan ikon prefix, tombol `Daftar Sekarang →`, dan link `Masuk`.
- Penyesuaian Alur Onboarding Tutorial: Dipindahkan ke alur **setelah login/register berhasil** (`Login` $\rightarrow$ `Onboarding` $\rightarrow$ `Home`).
- Pembersihan & Restrukturisasi Aset Gambar PNG: Folder `assets/` di root dihapus dan seluruh gambar PNG dipindahkan ke subfolder `lib/assets/` (`lib/assets/welcome/`, `lib/assets/parking/`, `lib/assets/home/`, `lib/assets/scan/`, dll).
- Sentralisasi Style & Theme System di `lib/shared/styles/`:
  - `app_colors.dart` (Token warna Light & Dark Theme).
  - `app_text_styles.dart` (Tipografi terpusat).
  - `app_theme.dart` (ThemeData Light & Dark Mode).
  - `theme_provider.dart` (State management toggle Light/Dark Mode dengan SharedPreferences persistence).
- Integrasi `ThemeProvider` di `AppProviders` (`main.dart`), `MyApp` (`app.dart`), serta opsi sakelar tema di `settings_page.dart` dan Halaman Masuk/Daftar.
- Redesign Dashboard Home, Denah Parkir, Peta Slot FT Unila, Status Parkir Aktif, Scanner QR, History, dan Profil Pengguna.
- Dokumentasi audit UI di `docs/ui_redesign_audit.md`.

## Sedang dikerjakan

- Review manual kode akhir.

## Tersisa

- Verifikasi visual runtime saat Flutter SDK tersedia di environment eksekusi.
