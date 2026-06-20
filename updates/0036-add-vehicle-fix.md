# Laporan Perbaikan: Fitur Tambah Kendaraan (Task 0036)

Laporan ini mendokumentasikan analisis root cause, perubahan berkas, payload, penanganan kesalahan spesifik dari backend, dan hasil pengujian untuk perbaikan fitur penambahan kendaraan baru di platform ParkFinder.

---

## 1. Root Cause Analysis (Penyebab Masalah)

### Masalah A: Payload Kontrak Tipe Kendaraan (Uppercase vs Lowercase)
* **Penyebab**: Formulir input tambah kendaraan pada bottom sheet menyajikan dropdown berisikan `"Mobil"`, `"Motor"`, dsb (Title Case). Ketika disubmit ke backend, nilai dikirimkan secara mentah tanpa dikonversi ke lowercase. Sementara itu, backend API `/users/vehicles` menetapkan aturan validasi ketat dan hanya menerima nilai lowercase (`"mobil"`, `"motor"`). Mengirimkan huruf kapital menyebabkan kegagalan validasi.

### Masalah B: Penanganan Error yang Tertelan (Swallowed Errors)
* **Penyebab**: `VehicleService.addVehicle` sebelumnya hanya mengembalikan `Vehicle?` (mengembalikan `null` jika response code bukan 200/201). Ini menyembunyikan detail penyebab kegagalan (misalnya plat nomor sudah terdaftar atau tipe kendaraan kosong), sehingga antarmuka hanya menampilkan pesan kesalahan umum `"Gagal menambahkan kendaraan. Coba lagi."`.

---

## 2. Payload Sebelum vs Sesudah (Payload Before vs After)

### Payload Sebelum Perbaikan
```json
{
  "plateNumber": "B 1234 XY",
  "vehicleType": "Mobil" // Kapital (Gagal validasi)
}
```

### Payload Sesudah Perbaikan
```json
{
  "plateNumber": "B 1234 XY",
  "vehicleType": "mobil" // Lowercase (Berhasil divalidasi)
}
```

---

## 3. Penanganan Respons Backend (Backend Response Handling)

### Response Sukses (200/201 OK)
```json
{
  "success": true,
  "message": "Vehicle added successfully",
  "data": {
    "plateNumber": "B 1234 XY",
    "vehicleType": "mobil"
  }
}
```

### Response Gagal (400 Bad Request)
```json
{
  "message": "plateNumber already exists"
}
```
* **Pemetaan Teks**: Respons gagal ini ditangkap di frontend dan dipetakan menjadi pesan yang ramah pengguna:
  * `"plateNumber already exists"` → `"Nomor kendaraan sudah terdaftar."`
  * `"vehicleType is required"` → `"Jenis kendaraan wajib dipilih."`

---

## 4. Berkas yang Diubah (Files Modified)

1. **`lib/features/profil/service/vehicle_service.dart`**:
   - Memperkenalkan model `AddVehicleResult` untuk membungkus status (`success`), data (`vehicle`), dan pesan kesalahan dari backend (`message`).
   - Menambahkan log `debugPrint` untuk merekam data payload dan respons dari backend secara transparan.
   - Mengubah `extractErrorMessage` agar memetakan pesan kegagalan backend ke pesan bahasa Indonesia yang ramah pengguna.
2. **`lib/features/profil/page/vehicle_management_page.dart`**:
   - Mengubah `_submit` pada `_AddVehicleBottomSheetState` untuk mengonversi jenis kendaraan ke lowercase (`_selectedType.toLowerCase()`) sebelum memanggil API.
   - Menghubungkan dialog sukses/gagal di halaman manajemen kendaraan agar menggunakan pesan terperinci dari `AddVehicleResult.message` secara langsung.

---

## 5. Bukti Refresh & Konsistensi Data (Refresh Proof)

* **Source of Truth Terjamin**: Setelah kendaraan berhasil ditambahkan, halaman langsung memanggil `_loadVehicles()` yang memicu refresh data profil (`GET /users/profile`) dari backend secara dinamis.
* **Integrasi Lintas Halaman**:
  - Halaman profil (`profil_widget.dart`) dan halaman edit profil (`edit_profil_page.dart`) telah diprogram menggunakan `.then((_) => _loadProfile())` ketika kembali dari manajemen kendaraan.
  - Ini memastikan bahwa kendaraan baru langsung muncul secara otomatis di semua halaman profil tanpa perlu memuat ulang aplikasi/refresh PWA secara manual.
  - Sesi login baru, logout, atau refresh halaman PWA tetap menampilkan data kendaraan terbaru karena bersumber langsung dari database backend.
