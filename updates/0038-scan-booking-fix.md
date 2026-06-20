# Laporan Perbaikan: Scan Tiket Gagal Booking (Task 0038)

Laporan ini mendokumentasikan analisis root cause, perubahan berkas, dan hasil pengujian untuk perbaikan bug di mana pengguna berhasil scan tiket parkir namun gagal melanjutkan booking slot.

---

## 1. Root Cause Analysis

### Masalah: Status Ticket Mismatch

Flow yang bermasalah:

```
Scan QR / input manual
 ↓
POST /access/verify → sukses, status: "claimed"
 ↓
GET /access/activeTicket → null (belum aktif)
 ↓
Fallback ke result verify (status "claimed")
 ↓
Save ke ActiveTicketStorage dengan status "claimed"
 ↓
Booking → _handleSlotBooking()
 ↓
if (activeTicket == null || activeTicket.status != 'active')
 ↓
NoTicketDialog → "Tiket Belum Diverifikasi"
```

**Penyebab 1 — Race Condition Aktivasi Tiket**: Backend `POST /access/verify` mengembalikan `status: "claimed"`, bukan `"active"`. Sementara `GET /access/activeTicket` bisa mengembalikan `null` karena aktivasi tiket membutuhkan waktu. Frontend sebelumnya hanya melakukan 1 kali panggilan tanpa retry.

**Penyebab 2 — Gate Status Terlalu Ketat**: `DetailBookingWidget._handleSlotBooking()` memeriksa `activeTicket.status != 'active'` dan langsung memblokir booking jika status bukan "active". Padahal tiket dengan status "claimed" sudah terverifikasi dan seharusnya valid untuk booking.

---

## 2. Flow Sebelum vs Sesudah

### Sebelum Perbaikan

```
Scan Tiket
  ↓
POST /access/verify → status "claimed"
  ↓
GET /access/activeTicket (1x, tanpa retry) → null
  ↓
Fallback: activeTicket ?? result → status "claimed"
  ↓
Save ke ActiveTicketStorage
  ↓
Booking: status != 'active' → ✗ BLOKIR
```

### Sesudah Perbaikan

```
Scan Tiket
  ↓
POST /access/verify → status "claimed"
  ↓
RETRY GET /access/activeTicket (max 3x, delay 500ms)
  ↓
  ├─ Berhasil → simpan activeTicket (status "active")
  └─ Gagal → fallback ke verify result (status "claimed")
  ↓
Save ke ActiveTicketStorage
  ↓
Booking: cek only activeTicket == null
  ↓
activeTicket != null → ✓ PROCEED BOOKING
  ↓
POST /reservations → sukses → slot ter-booked
```

---

## 3. Perubahan Kode

### File: `lib/features/welcome_scan/widget/welcome_scan_widget.dart`

**Perubahan**: Ekstrak logika resolve active ticket ke method `_resolveActiveTicket()` dengan retry mechanism.

```dart
// SEBELUM (di _verifyManualCode dan _onDetect):
final accessService = AccessService();
final activeTicket = await accessService.getActiveTicket();
final ticketData = activeTicket ?? result;
await ActiveTicketStorage().save(ticketData);

// SESUDAH:
final ticketData = await _resolveActiveTicket(result);
```

Method baru `_resolveActiveTicket`:
```dart
Future<TicketData> _resolveActiveTicket(TicketData verifyResult) async {
  const maxRetries = 3;
  const retryDelay = Duration(milliseconds: 500);
  final accessService = AccessService();

  for (int i = 0; i < maxRetries; i++) {
    final activeTicket = await accessService.getActiveTicket();
    if (activeTicket != null) {
      debugPrint('[Scan] Active ticket found on retry ${i + 1}: status=${activeTicket.status}');
      await ActiveTicketStorage().save(activeTicket);
      return activeTicket;
    }
    if (i < maxRetries - 1) {
      await Future.delayed(retryDelay);
    }
  }

  debugPrint('[Scan] No active ticket after $maxRetries retries, using verify result: status=${verifyResult.status}');
  await ActiveTicketStorage().save(verifyResult);
  return verifyResult;
}
```

### File: `lib/features/detail_booking/widget/detail_booking_widget.dart`

**Perubahan**: Hapus pengecekan `status != 'active'`, cukup cek `activeTicket == null`.

```dart
// SEBELUM:
if (activeTicket == null || activeTicket.status != 'active') {
  if (mounted) {
    setState(() => _isLoading = false);
    NoTicketDialog.show(context);
  }
  return;
}

// SESUDAH:
if (activeTicket == null) {
  if (mounted) {
    setState(() => _isLoading = false);
    NoTicketDialog.show(context);
  }
  return;
}
```

---

## 4. Debug Log (Hasil Pengujian API)

### Register User
```bash
POST /auth/register
→ 200 OK
→ Token: eyJhbGciOiJIUzI1NiIs...
→ User terdaftar: testuser38@example.com
```

### Get Areas (menampilkan area parkir yang tersedia)
```bash
GET /areas
→ 200 OK
→ Data:
  - Jurusan Teknik Elektro Unila (id: BWOjPZoajWmF3kJA62Fe) — 3 slot tersedia
  - Masjid Teknik Unila (id: WPo6iohpkwNSdj0Y79lx) — 3 slot tersedia
```

### Get Slots per Area
```bash
GET /areas/BWOjPZoajWmF3kJA62Fe/slots
→ 200 OK
→ 3 slot tersedia
```

---

## 5. Hasil Pengujian

### Verifikasi Build
| Item | Hasil |
|------|-------|
| `flutter analyze` | 0 error, 0 warning baru |
| `flutter build web` | Belum diuji (membutuhkan environment lengkap) |
| `flutter build apk` | Belum diuji (membutuhkan environment lengkap) |

### Skenario Pengujian Manual

| Skenario | Status | Keterangan |
|----------|--------|------------|
| Scan tiket via kamera | ⏳ Perlu tiket fisik | Membutuhkan QR code tiket parkir |
| Input kode manual | ⏳ Perlu kode tiket | Membutuhkan kode tiket valid dari backend |
| Booking setelah scan | ✅ Fix logic | Gate status tidak lagi blokir "claimed" |
| Retry activeTicket | ✅ Fix logic | 3x retry dengan delay 500ms |
| Slot ter-booked | ⏳ Perlu tiket | Membutuhkan tiket valid untuk booking |

**Catatan**: Pengujian end-to-end dengan tiket asli membutuhkan QR code tiket parkir dari gerbang masuk fisik. Perbaikan logic telah diverifikasi melalui code review dan flutter analyze.

---

## 6. Files Modified

| No | File | Perubahan |
|----|------|-----------|
| 1 | `lib/features/welcome_scan/widget/welcome_scan_widget.dart` | Tambah method `_resolveActiveTicket` dengan retry loop (3x, delay 500ms); panggil dari `_verifyManualCode` dan `_onDetect` |
| 2 | `lib/features/detail_booking/widget/detail_booking_widget.dart` | Hapus pengecekan `status != 'active'` pada gate booking, cukup cek `activeTicket == null` |
| 3 | `prompt.md` | Tambah TASK 0038 audit section lengkap |
