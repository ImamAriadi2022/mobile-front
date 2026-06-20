# Laporan Perbaikan: Pembaruan Logo Brand Aplikasi (Task 0037)

Laporan ini mendokumentasikan pembaruan seluruh logo brand aplikasi ParkFinder menggunakan logo baru (`logo.png`) untuk antarmuka pengguna (Splash Screen), ikon peluncur Android (launcher icons), serta ikon Progressive Web App (PWA).

---

## 1. Analisis & Latar Belakang

* **Sumber Aset Baru**: Pengguna menyediakan logo baru di `lib/assets/logo.png` (ukuran berkas: 221 KB).
* **Target Penggantian**:
  1. **Branding Aplikasi (Splash Screen)**: Sebelumnya memuat logo dari URL CDN eksternal (`/foto/logo.png`). Ini diganti menjadi aset lokal agar dapat dimuat secara instan dan mendukung fungsionalitas offline (offline-capable).
  2. **Ikon PWA (Web)**: Mengganti favicon dan ikon launcher PWA di folder `web/` dengan resolusi 192x192, 512x512, serta versi maskable.
  3. **Ikon Android (Launcher)**: Mengganti ikon peluncur bawaan (`ic_launcher.png`) untuk berbagai kerapatan piksel di folder mipmap Android (`android/app/src/main/res/`).

---

## 2. Berkas yang Diubah (Files Modified)

| No | Berkas | Deskripsi Perubahan |
|----|--------|---------------------|
| 1 | `pubspec.yaml` | Mendaftarkan `lib/assets/logo.png` di dalam objek `assets` agar dikemas bersama aplikasi Flutter. |
| 2 | `lib/features/splash_screen/widget/splash_screen_widget.dart` | Mengubah pemanggilan `CachedNetworkImage` / `Image.network` menjadi `Image.asset('lib/assets/logo.png')` lokal. Menghapus pustaka & konstanta CDN yang sudah tidak digunakan. |
| 3 | `web/favicon.png` | Diperbarui menggunakan logo baru (32x32). |
| 4 | `web/icons/Icon-192.png` & `Icon-512.png` | Ikon standar PWA diperbarui (192x192 & 512x512). |
| 5 | `web/icons/Icon-maskable-192.png` & `Icon-maskable-512.png` | Ikon adaptif maskable PWA diperbarui (192x192 & 512x512). |
| 6 | `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` | Ikon launcher Android mdpi diperbarui (48x48). |
| 7 | `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` | Ikon launcher Android hdpi diperbarui (72x72). |
| 8 | `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` | Ikon launcher Android xhdpi diperbarui (96x96). |
| 9 | `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` | Ikon launcher Android xxhdpi diperbarui (144x144). |
| 10 | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` | Ikon launcher Android xxxhdpi diperbarui (192x192). |

---

## 3. Otomatisasi & Langkah Pembuatan Aset (Asset Generation Steps)

Untuk memastikan kualitas kompresi gambar terbaik saat mereduksi dimensi gambar asli ke berbagai target resolusi, kami menggunakan pustaka `Pillow` (PIL) via Python.

### Script Pengonversi Aset (`resize_logo.py`):
```python
import os
from PIL import Image

logo_path = "/workspaces/mobile-front/lib/assets/logo.png"

targets = {
    # Web PWA
    "/workspaces/mobile-front/web/icons/Icon-192.png": (192, 192),
    "/workspaces/mobile-front/web/icons/Icon-512.png": (512, 512),
    "/workspaces/mobile-front/web/icons/Icon-maskable-192.png": (192, 192),
    "/workspaces/mobile-front/web/icons/Icon-maskable-512.png": (512, 512),
    "/workspaces/mobile-front/web/favicon.png": (32, 32),
    
    # Android launcher icons
    "/workspaces/mobile-front/android/app/src/main/res/mipmap-mdpi/ic_launcher.png": (48, 48),
    "/workspaces/mobile-front/android/app/src/main/res/mipmap-hdpi/ic_launcher.png": (72, 72),
    "/workspaces/mobile-front/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": (96, 96),
    "/workspaces/mobile-front/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": (144, 144),
    "/workspaces/mobile-front/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": (192, 192),
}

img = Image.open(logo_path)
for path, size in targets.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    resized_img = img.resize(size, Image.Resampling.LANCZOS)
    resized_img.save(path, format="PNG")
```

---

## 4. Hasil Kompilasi & Pengujian

1. **Analisis Kode (`flutter analyze`)**: Berhasil tanpa ada error (0 Error).
2. **Kompilasi PWA (`flutter build web`)**: Sukses membangun folder `build/web` yang memuat seluruh perubahan ikon terbaru.
3. **Penyalinan Aset Target**: Seluruh berkas hasil build disalin ulang ke folder [pwa/](file:///workspaces/mobile-front/pwa).
