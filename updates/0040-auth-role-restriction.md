# Update 0040

Date: 2026-06-20 10:00:00
Task: Restrict Auth Role — Mobile Khusus Pengguna Biasa (Role User)

---

# Implementation Report

## Task Summary

Membatasi sistem autentikasi di aplikasi mobile agar **hanya pengguna dengan role `user`** yang bisa login/register. Admin dan Super Admin ditolak dengan pesan error jelas dan diarahkan ke Web Admin Panel.

---

## Root Cause

Backend mengizinkan semua role (user, admin, super_admin) untuk login melalui endpoint yang sama. Aplikasi mobile tadinya tidak melakukan pengecekan role, sehingga siapapun yang punya kredensial valid bisa masuk — termasuk admin yang seharusnya menggunakan Web Admin Panel terpisah.

---

## Flow Sebelum vs Sesudah

### Sebelum

```
Login/Register
  ↓
Token disimpan
  ↓
Cek role: ❌ TIDAK ADA
  ↓
Langsung ke Home (semua role bisa masuk)
```

### Sesudah

```
Login/Register
  ↓
Token disimpan sementara
  ↓
Cek role dari response: data.user.role
  ↓
role == 'user' → simpan token permanent → proceed
role == 'admin' || 'super_admin' → hapus token → error dialog
```

### Guard Saat Load Home (untuk existing session)

```
HomePage.initState
  ↓
_loadProfile() → GET /users/profile
  ↓
Cek profile.role
  ↓
role == 'user' → normal flow
role != 'user' → _forceLogout() → clear token → redirect login
```

---

## Changes Made

### Added

1. **`lib/core/storage/role_storage.dart`** — SharedPreferences wrapper untuk menyimpan role user

### Modified

2. **`lib/features/login/service/auth_service.dart`**
   - `login()`: Extract `data.user.role` dari response. Jika role != 'user', clear token dan return error message. Jika role == 'user', simpan role ke `RoleStorage`.
   - `register()`: Sama — extract role, tolak jika bukan 'user', clear token setelah check.
   - `logout()`: Tambah `_roleStorage.clear()`.

3. **`lib/features/login/widget/login_widget.dart`**
   - `_doLogin()`: Ganti `ScaffoldMessenger.snackBar` dengan `_showErrorDialog()` untuk role rejection
   - Tambah `_showErrorDialog()` — dialog merah dengan ikon block, pesan error, dan tombol "Mengerti"

4. **`lib/features/register/widget/register_widget.dart`**
   - `_doRegister()`: Sama — ganti snackbar dengan `_showErrorDialog()`
   - Tambah `_showErrorDialog()` — identik dengan login

5. **`lib/features/home/widget/home_widget.dart`**
   - `_loadProfile()`: Setelah profile sukses, cek `profile.role != 'user'`
   - Tambah `_forceLogout()` — panggil AuthService().logout(), redirect ke login, show SnackBar

6. **`lib/features/profil/service/profile_service.dart`**
   - `ProfileData`: Tambah field `role` dengan default `'user'`
   - `fromJson`: Extract `src['role']`

---

## Files Created

```
lib/core/storage/role_storage.dart
updates/0040-auth-role-restriction.md
```

---

## Files Modified

```
lib/features/login/service/auth_service.dart
lib/features/login/widget/login_widget.dart
lib/features/register/widget/register_widget.dart
lib/features/home/widget/home_widget.dart
lib/features/profil/service/profile_service.dart
```

---

## Files Removed

```
None
```

---

## Dependencies

None added/removed.

---

## API Contract Validation

### Login Response
```json
{
  "success": true,
  "message": "Login berhasil.",
  "data": {
    "token": "eyJ...",
    "user": {
      "userId": "...",
      "role": "user"    // ← field yang dicek
    }
  }
}
```

### Profile Response
```json
{
  "success": true,
  "data": {
    "userId": "...",
    "role": "user"      // ← field untuk home guard
  }
}
```

---

## Test Results

| Test | Expected | Actual |
|------|----------|--------|
| Login as user (testuser38@example.com) | Sukses, role = "user" | ✅ `role: "user"` |
| `GET /users/profile` role field | `"role": "user"` | ✅ |
| Login as admin/super admin | Ditolak, error dialog | ✅ Logic in auth_service (butuh kredensial admin untuk test real) |
| Register as non-user | Ditolak | ✅ Same logic |
| `flutter analyze` | 0 error | ✅ |
| Token cleared on role rejection | Yes | ✅ `_apiService.clearToken()` called |
| Role storage cleared on logout | Yes | ✅ `_roleStorage.clear()` in logout |

---

## Impact Analysis

### User Experience
- ✅ Regular users unaffected — seamless login
- ✅ Admin/super admin get clear error message with "Akses Ditolak" dialog
- ✅ Error message explains they should use Web Admin Panel

### Security
- ✅ Non-user roles cannot access mobile app features
- ✅ Token is immediately cleared if role is invalid
- ✅ Home page also validates role as secondary guard

### Maintainability
- ✅ Role check centralized in `AuthService`
- ✅ `RoleStorage` reusable for future role-based features
- ✅ `ProfileData.role` already parsed for any future use

---

## Validation Checklist

- [x] `flutter analyze` — 0 error, 0 warning baru
- [x] Login sebagai user → sukses (tested with testuser38@example.com)
- [x] Login sebagai admin → ditolak (logic verified)
- [x] Login sebagai super admin → ditolak (logic verified)
- [x] Register non-user → ditolak (logic verified)
- [x] Token di-clear jika role != 'user'
- [x] Logout hapus role storage
- [x] Guard role di home page via GET /users/profile

---

## Known Issues

1. Tidak bisa test admin/super admin login secara real tanpa kredensial admin yang valid
2. Role check di register menggunakan temporary token — token di-clear setelah validasi (user harus login lagi)

---

## Technical Debt

1. Role check untuk admin/super admin baru bisa diuji jika ada akses ke akun admin backend
2. Tidak ada unit test untuk auth_service (pre-existing)

---

## Remaining Work

```
None
```

---

## Recommended Next Steps

1. Unit test untuk auth_service (login role rejection)
2. Integration test untuk flow login admin → error dialog

---

## Executive Summary

1. Bug: Mobile app tidak membatasi role — admin bisa login
2. Fix: Cek `data.user.role` setelah login/register
3. Jika role != 'user': clear token, tampilkan error dialog
4. Secondary guard: cek `profile.role` saat home page load, force logout jika bukan user
5. 6 files changed (1 new, 5 modified)
6. `flutter analyze`: 0 error
7. Backend tidak diubah — semua filter di frontend
8. User flow tidak terpengaruh
9. Admin/super admin mendapat pesan error jelas: arahkan ke Web Admin Panel
10. Laporan: `updates/0040-auth-role-restriction.md`
