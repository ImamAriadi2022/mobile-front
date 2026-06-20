# Update 0043

Date: 2026-06-20 10:36:00
Task: Integrasi Sinkronisasi Real-Time Timer dan Data Daftar Parkir Dashboard

---

# Implementation Report

## Task Summary

Menyelesaikan integrasi data daftar parkir riil pada halaman utama (HomePage) dan mengaktifkan fungsionalitas timer dinamis secara real-time pada halaman status kendaraan aktif (StatusKendaraanPage).

---

## Technical Solutions & Implementations

### 1. Data Area Parkir Dinamis pada HomePage
Peta data parkir terdekat pada halaman dashboard `/home` (dikelola oleh `HomeWidget`) sudah terintegrasi secara dinamis dengan memanggil API `GET /areas` melalui `BookingService().getAreas()`. Data tersebut kemudian di-render secara dinamis menggunakan `ParkingListItemWidget` dan mendukung transisi ke menu detail booking dengan parameter `areaId` yang tepat.
- Menangani loading state (`CircularProgressIndicator`) saat data sedang di-fetch.
- Menangani error state dengan ramah (menampilkan pesan error dan tombol "Coba Lagi" yang men-trigger pemanggilan API ulang).

### 2. Timer Durasi Parkir Aktif Real-Time pada StatusKendaraanPage
- **Pembaruan Model `TicketData`**: Menambahkan properti `claimedAt` pada model `TicketData` (`lib/features/welcome_scan/service/scan_service.dart`) agar timestamp saat tiket pertama kali diklaim/di-scan oleh pengguna dapat diparse dan diserialisasi dengan aman.
- **Perhitungan Waktu di `StatusKendaraanPage`**: Modifikasi metode `_startElapsedTimer()` pada `lib/features/home/page/status_kendaraan_page.dart` untuk membaca properti `claimedAt` dari tiket aktif (`_activeTicket`). Selisih waktu dihitung secara akurat menggunakan `DateTime.now().difference(claimedTime).inSeconds`.
- **Timer Increment Berkala**: Menggunakan `Timer.periodic` untuk memperbarui durasi parkir (`_elapsedSeconds`) setiap 1 detik. Hal ini mencegah timer macet (stuck) atau reset ke 0 saat halaman ditutup dan dibuka kembali.

---

## Changes Made

### Modified

1. **`lib/features/welcome_scan/service/scan_service.dart`**
   - Menambahkan properti `claimedAt` ke dalam konstruktor `TicketData`, metode factory `fromJson`, dan metode `toJson`.

2. **`lib/features/home/page/status_kendaraan_page.dart`**
   - Mengubah `_startElapsedTimer()` agar menghitung durasi parkir berbasis selisih waktu riil dengan parameter `claimedAt` (pada tiket) atau `startTime` (pada reservasi), sehingga tidak mereset nilai durasi saat halaman dibuka kembali.

---

## Files Created

```
updates/0043-realtime-timer-dashboard-areas.md
```

---

## Files Modified

```
lib/features/welcome_scan/service/scan_service.dart
lib/features/home/page/status_kendaraan_page.dart
```

---

## Files Removed

```
None
```

---

## Dependencies Added

```
None
```

---

## Folder Structure Changes

```
None
```

---

## Technical Details

### Model Parsing updates in `scan_service.dart`:
```dart
  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketCode: json['ticketId'] ?? json['ticketCode'] ?? json['code'] ?? json['id'] ?? '',
      status: json['status'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      areaId: json['areaId'] ?? '',
      areaName: json['areaName'] ?? '',
      bindingId: json['bindingId'] ?? '',
      claimedAt: json['claimedAt'] ?? '',
    );
  }
```

### Time calculation updates in `status_kendaraan_page.dart`:
```dart
    } else if (_activeTicket != null &&
        _activeTicket!.ticketCode.isNotEmpty &&
        (_activeTicket!.status == 'active' ||
            _activeTicket!.status == 'claimed')) {
      // Fallback: use claimedAt timestamp if available, otherwise start from 0
      if (_activeTicket!.claimedAt.isNotEmpty) {
        try {
          final claimedTime = DateTime.parse(_activeTicket!.claimedAt);
          _elapsedSeconds = DateTime.now().difference(claimedTime).inSeconds;
          if (_elapsedSeconds < 0) _elapsedSeconds = 0;
        } catch (_) {
          _elapsedSeconds = 0;
        }
      } else {
        _elapsedSeconds = 0;
      }
```

---

## Validation Checklist

* [x] Build berhasil
* [x] `flutter test` berjalan sukses
* [x] `flutter analyze` 0 error (174 info warnings)
* [x] Timer parkir bertambah dinamis secara real-time setiap detik
* [x] Waktu terhitung akurat dari waktu klaim tiket dan tidak mereset saat halaman direload

---

## Known Issues

```
None
```

---

## Technical Debt

```
None
```

---

## Remaining Work

Sisa pengerjaan pada Fase berikutnya (Riwayat booking & Form edit profil).

---

## Recommended Next Steps

1. Integrasi data riwayat reservasi parkir dari API pada `HistoryPage`.
2. Hubungkan form edit profil dengan endpoint update profile di backend.
