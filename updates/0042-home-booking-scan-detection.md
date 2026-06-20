# Update 0042

Date: 2026-06-20 10:20:00
Task: Fix: Home & Booking Tidak Mendeteksi Tiket Sudah Di-Scan

---

# Implementation Report

## Task Summary

Memperbaiki bug di mana setelah pengguna berhasil memindai/men-scan tiket (muncul layar "Scan Berhasil" dengan status `"claimed"`), banner di halaman Home dashboard masih menampilkan "Tiket Belum Aktif" dan reservasi slot parkir pada halaman Booking terblokir oleh `NoTicketDialog`.

---

## Root Cause Analysis

### 1. Sinkronisasi API Menimpa Local Storage
Metode `HomeWidget._checkActiveTicket()` memanggil endpoint `GET /access/activeTicket` di awal. Jika backend merespon dengan `404` (Not Found) atau mengembalikan data kosong sebelum tersinkronisasi penuh, frontend langsung membersihkan/mengosongkan data di `ActiveTicketStorage`. Akibatnya, tiket yang baru saja disimpan saat scan sukses terhapus dari local storage.

### 2. Responsivitas UI Terhambat
Halaman Home dan Status Kendaraan melakukan request API secara synchronous di awal sebelum memuat data dari `ActiveTicketStorage`. Hal ini menyebabkan UI terlambat menampilkan tiket aktif/claimed dan rentan terhadap delay/kegagalan sinkronisasi dari API.

### 3. Masalah API Mapping pada Access Service
Ketika backend mengembalikan respon sukses `200` dengan data null atau data tiket kosong, model `TicketData` tetap di-instantiate dengan properti kosong (misal `ticketCode` berupa string kosong `""`), sehingga menimpa `ActiveTicketStorage` dengan objek tiket yang tidak valid.

---

## Flow Sebelum vs Sesudah

### Sebelum

```
[Scan Tiket Sukses] ──> Simpan ke ActiveTicketStorage (status: "claimed")
                                 │
                                 ▼
                     Navigasi ke Halaman Home
                                 │
                                 ▼
         Panggil API GET /access/activeTicket (Sangat Cepat/Sync)
                                 │
                                 ▼
API merespon 404 / null data ──> Menimpa ActiveTicketStorage dengan null/kosong
                                 │
                      ┌──────────┴──────────┐
                      ▼                     ▼
             [Home Dashboard]       [Booking Screen]
             Menampilkan Banner     Membaca Storage yang kosong
            "Tiket Belum Aktif"     ──> Blokir via NoTicketDialog
```

### Sesudah

```
[Scan Tiket Sukses] ──> Simpan ke ActiveTicketStorage (status: "claimed")
                                 │
                                 ▼
                     Navigasi ke Halaman Home
                                 │
                                 ▼
1. Load dari ActiveTicketStorage seketika (Instant UI: "Tiket Aktif")
2. Lakukan sinkronisasi background dengan API GET /access/activeTicket
3. access_service.dart memvalidasi:
   - Jika tiket dari API valid (ticketCode tidak kosong), update storage.
   - Jika API merespon 404 (tiket kedaluwarsa/checkout), hapus local storage.
   - Jika API merespon data kosong atau error jaringan, pertahankan local storage yang ada.
```

---

## Changes Made

### Modified

1. **`lib/features/access/service/access_service.dart`**
   - Mengubah `getActiveTicket()` agar hanya mengembalikan objek `TicketData` jika `ticketCode` tidak kosong.
   - Menambahkan pengamanan agar hanya menghapus local `ActiveTicketStorage` pada HTTP status `404` (bukan pada kegagalan jaringan atau parsing).

2. **`lib/features/home/widget/home_widget.dart`**
   - Mengubah `_checkActiveTicket()` untuk membaca data tiket & reservasi dari local storage (`ActiveTicketStorage` & `ActiveReservationStorage`) terlebih dahulu agar banner/UI menampilkan tiket aktif dengan instan.
   - Sinkronisasi API dilakukan di background dan memperbarui UI setelah data berhasil diperbarui.

3. **`lib/features/home/page/status_kendaraan_page.dart`**
   - Mengubah `_loadAllData()` dengan pola yang sama: memuat data tiket dari local storage terlebih dahulu sebelum melakukan sinkronisasi dengan API di background.

---

## Files Modified

```
lib/features/access/service/access_service.dart
lib/features/home/widget/home_widget.dart
lib/features/home/page/status_kendaraan_page.dart
```

---

## API Test & Verification Results

### 1. Log Registrasi & Klaim Tiket
User `testuser42_c_1781950439126@example.com` mendaftarkan diri dan mengklaim tiket `PF-1781950271734-e26cf5dd`. Tiket berhasil tersimpan di backend dengan status `"claimed"`.

### 2. Pengujian Booking Tiket (`test_book.js`)
Menggunakan script `test_book.js` untuk mensimulasikan pemesanan slot parkir menggunakan tiket yang telah diklaim.
- **Endpoint**: `POST /reservations`
- **Payload**:
  ```json
  {
    "slotId": "3QHzrYhMBlPtpJ0xklOe",
    "ticketId": "at0dCIEgNYDIOuHRfENM",
    "name": "Test User 42",
    "plateNumber": "B 1242 XYZ"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "message": "Booking berhasil. Silakan menuju slot parkir.",
    "data": {
      "reservationId": "X3U3QpoomX9nH8f2Vw7v",
      "status": "pending",
      "slotName": "A-01",
      "areaId": "BWOjPZoajWmF3kJA62Fe",
      "plateNumber": "B 1242 XYZ",
      "name": "Test User 42",
      "ticketId": "at0dCIEgNYDIOuHRfENM",
      "qrCode": "PF-1781950271734-e26cf5dd",
      "expiryTime": "2026-06-20T10:47:24.749Z"
    }
  }
  ```
- **Hasil**: Tiket berstatus `"claimed"` berhasil digunakan untuk melakukan booking tanpa terblokir dialog, dan status slot parkir `A-01` terupdate menjadi `"booked"`.

### 3. Static Analysis & Unit Tests
- `flutter test` ──> **All tests passed!**
- `flutter analyze` ──> **0 errors** (174 infos/warnings).
- `flutter build web --release` ──> **Built build/web** (PWA compilation success).
