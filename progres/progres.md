# Progress Proyek Redesign ParkFinder

## Selesai

- **Perbaikan Bug Bottom Navigation Bar Dark Mode**: Memperbarui [bottom_nav_bar.dart](file:///c:/programming/mobile-front/lib/shared/widgets/bottom_nav_bar.dart) agar latar belakang (`AppColors.navBarDark`/`AppColors.navBarLight`), garis tepi, dan warna ikon tak terpilih beradaptasi secara dinamis saat beralih antara Mode Terang dan Mode Gelap.
- **Perbaikan Kontras Warna & Style Terpusat di Profil & Pengaturan**:
  - Memperbarui [settings_row_item_widget.dart](file:///c:/programming/mobile-front/lib/shared/widgets/settings_row_item_widget.dart), [edit_profile_page.dart](file:///c:/programming/mobile-front/lib/features/profile/pages/edit_profile_page.dart), [profile_avatar_widget.dart](file:///c:/programming/mobile-front/lib/features/profile/widgets/profile_avatar_widget.dart), dan [settings_page.dart](file:///c:/programming/mobile-front/lib/features/profile/pages/settings_page.dart) menggunakan token warna terpusat (`AppColors.getBackgroundColor`, `AppColors.getCardBg`, `AppColors.getTextPrimary`, `AppColors.getTextSecondary`).
  - Mengeliminasi 100% masalah teks putih di atas latar belakang putih pada halaman Profil, Edit Profil, dan Pengaturan.
- **Re-build & Ekspor PWA**: Berhasil mengompilasi ulang Flutter PWA (`flutter build web --release`) dan memperbarui seluruh berkas di direktori root `pwa/`.
- **Penyesuaian Alur Tutorial & Onboarding**: Menghapus transisi tutorial lama yang berlebihan; alur dipusatkan sepenuhnya melalui Onboarding (`WelcomeWidget`) setelah login/register berhasil (`Splash` $\rightarrow$ `Login` $\rightarrow$ `Onboarding` $\rightarrow$ `Home`).
- **Redesign Halaman Beranda (Home)**: Menyesuaikan 100% dengan `Dashboard Parkir.png`.
- **Redesign Area Parkir & Denah Slot**:
  - `BookingWidget` disesuaikan 100% dengan `Denah.png`.
  - `DetailBookingWidget` & `ParkingSlotItemWidget` disesuaikan 100% dengan `Peta Parkir FT Unila.png`.
- **Implementasi Dark & Light Mode Toggle After Login**: Ikon sakelar tema hadir di `UserHeaderWidget` pada semua halaman pasca-login.
- **Batasan Tipe Kendaraan (Hanya Mobil)**: Membatasi seluruh formulir dan tampilan kendaraan khusus untuk jenis **Mobil**.
- Redesign presisi Halaman Masuk (`login_widget.dart`) & Halaman Daftar (`register_widget.dart`).
- Dokumentasi audit UI di `docs/ui_redesign_audit.md`.

## Sedang dikerjakan

- Selesai.

## Tersisa

- Tidak ada.
