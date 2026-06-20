# Laporan Perbaikan Bug & UI: Selesai Parkir - TASK 0046

### 1. Masalah / Bug
1. Ketika pengguna ingin mengakhiri sesi parkir dengan menekan tombol "Keluar Parkir", backend merespons dengan status `404 Not Found` karena request dikirim menggunakan HTTP method `POST` ke endpoint `/reservations/{id}/complete`. Endpoint ini sebenarnya memerlukan method `PATCH`.
2. Penamaan tombol utama di layar sesi aktif (`StatusKendaraanPage`) masih menggunakan label "Keluar Parkir", yang dirasa kurang intuitif atau selaras dengan status kendaraan yang sudah diparkir.

### 2. Perbaikan yang Dilakukan
1. **Perubahan HTTP Method**:
   Mengubah method pemanggilan API pada `ParkingService.completeReservation()` di [parking_service.dart](file:///workspaces/mobile-front/lib/features/home/service/parking_service.dart) dari `POST` menjadi **`PATCH`**:
   ```dart
   final response = await _apiService.patch(
     '/reservations/$reservationId/complete',
     requireAuth: true,
   );
   ```

2. **Pembaruan Label Tombol di UI**:
   Mengubah label tombol utama pada widget `_buildActiveOrArrivedView` di [status_kendaraan_page.dart](file:///workspaces/mobile-front/lib/features/home/page/status_kendaraan_page.dart) dari **"Keluar Parkir"** menjadi **"Selesai Parkir"** agar selaras dengan alur fungsional penyelesaian sesi parkir.
   ```dart
   : const Text(
       'Selesai Parkir',
       style: TextStyle(
         color: Colors.white,
         fontSize: 18,
         fontWeight: FontWeight.w600,
       ),
     ),
   ```

3. **PWA Rebuild**:
   Melakukan kompilasi ulang kode dengan `flutter build web --release` dan memperbarui aset PWA di direktori `pwa/` dengan file `main.dart.js` yang baru.

### 3. File yang Dimodifikasi
- [lib/features/home/service/parking_service.dart](file:///workspaces/mobile-front/lib/features/home/service/parking_service.dart)
- [lib/features/home/page/status_kendaraan_page.dart](file:///workspaces/mobile-front/lib/features/home/page/status_kendaraan_page.dart)
- [progres/progres.md](file:///workspaces/mobile-front/progres/progres.md)
- [pwa/flutter_bootstrap.js](file:///workspaces/mobile-front/pwa/flutter_bootstrap.js)
- [pwa/main.dart.js](file:///workspaces/mobile-front/pwa/main.dart.js)

### 4. Hasil Verifikasi
- Pengujian statis dengan `flutter analyze` menghasilkan 0 error.
- Proses build untuk platform web/PWA berjalan lancar dan menghasilkan kompilasi siap pakai di `pwa/`.
