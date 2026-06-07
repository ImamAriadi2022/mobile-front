# Revisi API Scan Tiket (Untuk Tim Backend)

## Ringkasan Masalah
Di integrasi web user untuk proses scan tiket, endpoint `POST /access/verify` saat ini menolak field `ticketId` dengan pesan seperti:
- `ticketId is not allowed`

Sementara dokumentasi API saat ini menulis body verify menggunakan `ticketId`.

Akibatnya terjadi ketidaksesuaian antara dokumentasi dan perilaku backend, dan proses aktivasi tiket gagal di sisi client.

## Temuan Kontrak Saat Ini
- Implementasi backend aktual menerima: `qrCode`
- Implementasi backend aktual menolak: `ticketId`
- Dokumentasi `api.md` (bagian Access & Guest Access) masih menuliskan verify body dengan `ticketId`

## Dampak
- Client yang mengikuti dokumentasi (mengirim `ticketId`) gagal verifikasi tiket.
- Proses scan QR jadi tidak konsisten antar aplikasi/klien.

## Permintaan Revisi ke Backend
Mohon pilih salah satu opsi kontrak berikut dan dipastikan konsisten di code + docs:

1. Opsi A (disarankan): standar tunggal pakai `qrCode`
- `POST /access/verify` menerima body:
```json
{
  "qrCode": "string"
}
```
- `ticketId` tidak digunakan lagi di endpoint verify.
- Dokumentasi diperbarui penuh (User + Guest).

2. Opsi B: backward-compatible
- `POST /access/verify` menerima keduanya (`qrCode` atau `ticketId`) untuk masa transisi.
- Jika dua field dikirim, backend menetapkan prioritas yang jelas.
- Dokumentasi menyebutkan masa deprecate `ticketId` dan tanggal sunset.

## Permintaan Standarisasi Tambahan
Agar integrasi stabil lintas klien:

1. Error schema konsisten
- Mohon error response konsisten, misalnya:
```json
{
  "message": "string",
  "code": "string",
  "details": {}
}
```

2. Definisikan perilaku tiket tidak ditemukan / sudah dipakai
- Contoh mapping status:
- `404` tiket tidak ditemukan
- `409` tiket sudah tidak aktif/sudah digunakan
- `400` format payload invalid

3. Jelaskan kontrak auth verify
- Pastikan jelas apakah endpoint verify guest butuh token atau tidak.
- Jika endpoint sama untuk user + guest, dokumentasi harus menjelaskan perbedaan behavior.

4. Dokumentasikan fitur force-activate (jika memang ada)
- Saat ini tidak ada kontrak resmi untuk force activate/create if not exists.
- Jika memang dibutuhkan, mohon endpoint/flag resmi didokumentasikan (termasuk risiko dan otorisasi).

## Checklist Revisi Dokumen API
- [ ] Perbarui request body `POST /access/verify` di semua section terkait.
- [ ] Tambahkan contoh response sukses dan response error nyata.
- [ ] Tambahkan tabel validasi field dan status code.
- [ ] Tambahkan catatan kompatibilitas (jika mendukung dua field sementara).

## Catatan Integrasi Frontend Saat Ini
Sementara ini frontend web user sudah disesuaikan mengirim:
```json
{
  "qrCode": "..."
}
```
agar sesuai perilaku backend saat ini.

## Klarifikasi Alur yang Diinginkan
- Website QR generator di backend menghasilkan kode QR/tiket.
- Tiket dianggap aktif dari sisi backend saat QR tersebut dibuat/diambil.
- Web user yang melakukan scan tidak perlu mengirim `ticketId`.
- Endpoint scan/verify cukup menerima `qrCode` sebagai identitas tiket.

Dengan alur ini, `ticketId` sebaiknya tidak dipakai pada request scan web user agar tidak memicu error validasi `ticketId is not allowed`.
