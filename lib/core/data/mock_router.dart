import 'package:http/http.dart' as http;
import 'mock_data.dart';
import 'mock_response.dart';

class MockRouter {
  static Future<http.Response> handle({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(endpoint);
    final path = uri.path;

    switch (method) {
      case 'GET':
        return _handleGet(path);
      case 'POST':
        return _handlePost(path, body ?? {});
      case 'PUT':
        return _handlePut(path, body ?? {});
      case 'PATCH':
        return _handlePatch(path, body ?? {});
      case 'DELETE':
        return _handleDelete(path);
      default:
        return MockResponse.error('Method not supported: $method',
            statusCode: 405);
    }
  }

  static Future<http.Response> _handleGet(String path) async {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    // GET /areas
    if (path == '/areas' || path == 'areas') {
      final areas = await MockDatabase.getAreas();
      return MockResponse.okList(areas);
    }

    // GET /areas/{id}/slots
    if (path.contains('/slots') && segments.length >= 3) {
      final areaId = segments[1];
      final slots = await MockDatabase.getSlots(areaId);
      return MockResponse.okList(slots);
    }

    // GET /auth/check (internal)
    if (path.contains('/auth/check')) {
      final loggedIn = await MockDatabase.isLoggedIn();
      return MockResponse.ok({'loggedIn': loggedIn});
    }

    // GET /users/profile
    if (path == '/users/profile' || path == 'users/profile') {
      final profile = await MockDatabase.getProfile();
      final vehicles = await MockDatabase.getVehicles();
      profile['vehicles'] = vehicles;
      return MockResponse.okWithData(profile);
    }

    // GET /users/{id}/reservations (history)
    if (path.contains('/reservations') && segments.length >= 3) {
      final history = await MockDatabase.getHistory();
      return MockResponse.okList(history);
    }

    // GET /users/vehicles
    if (path == '/users/vehicles' || path == 'users/vehicles') {
      final vehicles = await MockDatabase.getVehicles();
      return MockResponse.okList(vehicles);
    }

    // GET /access/activeTicket
    if (path == '/access/activeTicket') {
      final ticket = await MockDatabase.getActiveTicket();
      if (ticket != null) {
        return MockResponse.ok({'success': true, 'data': ticket});
      }
      return MockResponse.ok({'success': true, 'data': null});
    }

    return MockResponse.error('Not found: $path', statusCode: 404);
  }

  static Future<http.Response> _handlePost(
      String path, Map<String, dynamic> body) async {
    // POST /auth/login
    if (path == '/auth/login') {
      final email = body['email'] as String? ?? '';
      final password = body['password'] as String? ?? '';

      if (email.isEmpty || password.isEmpty) {
        return MockResponse.error('Email dan password harus diisi.');
      }
      if (password.length < 6) {
        return MockResponse.error('Password minimal 6 karakter.');
      }

      final mockProfile = await MockDatabase.getProfile();
      await MockDatabase.saveToken('mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}');
      await MockDatabase.saveRole('user');

      return MockResponse.ok({
        'success': true,
        'message': 'Login berhasil.',
        'data': {
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'userId': mockProfile['userId'],
            'name': mockProfile['name'],
            'email': mockProfile['email'],
            'role': 'user',
          },
        },
      });
    }

    // POST /auth/register
    if (path == '/auth/register') {
      final name = body['name'] as String? ?? '';
      final email = body['email'] as String? ?? '';

      if (name.isEmpty || email.isEmpty) {
        return MockResponse.error('Nama dan email harus diisi.');
      }

      final newProfile = await MockDatabase.getProfile();
      newProfile['name'] = name;
      newProfile['email'] = email;
      newProfile['phoneNumber'] = body['phoneNumber'] ?? '';
      final plate = body['defaultLicensePlate'] as String? ?? '';
      if (plate.isNotEmpty) {
        final vehicles = await MockDatabase.getVehicles();
        vehicles.add({
          'plateNumber': plate,
          'vehicleType': body['vehicleType'] ?? 'mobil',
        });
        await MockDatabase.saveVehicles(vehicles);
      }
      await MockDatabase.saveProfile(newProfile);

      return MockResponse.ok({
        'success': true,
        'message': 'Pendaftaran berhasil. Silakan login.',
        'data': newProfile,
      });
    }

    // POST /auth/logout
    if (path == '/auth/logout') {
      await MockDatabase.clearToken();
      await MockDatabase.clearRole();
      await MockDatabase.clearActiveTicket();
      await MockDatabase.clearActiveReservation();
      return MockResponse.ok({'success': true, 'message': 'Logout berhasil.'});
    }

    // POST /access/verify
    if (path == '/access/verify') {
      final qrCode = body['qrCode'] as String? ?? '';

      if (qrCode.isEmpty) {
        return MockResponse.error('QR Code tidak valid.');
      }

      final ticket = {
        'ticketId': qrCode,
        'ticketCode': qrCode,
        'id': qrCode,
        'code': qrCode,
        'status': 'active',
        'vehicleType': 'mobil',
        'areaId': 'area-001',
        'areaName': 'Teknik Elektro Universitas Lampung',
        'bindingId': 'bind-${qrCode.hashCode}',
        'claimedAt': DateTime.now().toIso8601String(),
      };
      await MockDatabase.saveActiveTicket(ticket);

      return MockResponse.ok({
        'success': true,
        'data': ticket,
      });
    }

    // POST /reservations
    if (path == '/reservations') {
      final slotId = body['slotId'] as String? ?? '';
      final ticketId = body['ticketId'] as String? ?? '';

      if (slotId.isEmpty) {
        return MockResponse.error('Slot ID harus diisi.');
      }

      final reservationId = 'RSV-${DateTime.now().millisecondsSinceEpoch}';

      await MockDatabase.saveActiveReservation({
        'reservationId': reservationId,
        'status': 'pending',
        'slotId': slotId,
        'slotName': slotId.split('-').last,
        'areaId': 'area-001',
        'ticketId': ticketId,
        'startTime': DateTime.now().toIso8601String(),
      });

      return MockResponse.created({
        'success': true,
        'message': 'Booking berhasil.',
        'data': {
          'reservationId': reservationId,
          'status': 'pending',
        },
      });
    }

    // POST /access/cancelTicket
    if (path == '/access/cancelTicket') {
      await MockDatabase.clearActiveTicket();
      return MockResponse.ok({
        'success': true,
        'message': 'Tiket berhasil dibatalkan.',
      });
    }

    // POST /users/vehicles
    if (path == '/users/vehicles') {
      final plateNumber = body['plateNumber'] as String? ?? '';
      final vehicleType = body['vehicleType'] as String? ?? 'mobil';

      if (plateNumber.isEmpty) {
        return MockResponse.error('Plat nomor harus diisi.');
      }

      final vehicles = await MockDatabase.getVehicles();
      final exists = vehicles.any((v) => v['plateNumber'] == plateNumber);
      if (exists) {
        return MockResponse.error('Nomor kendaraan sudah terdaftar.',
            statusCode: 409);
      }

      final newVehicle = {
        'plateNumber': plateNumber,
        'vehicleType': vehicleType,
      };
      vehicles.add(newVehicle);
      await MockDatabase.saveVehicles(vehicles);

      return MockResponse.created({
        'success': true,
        'message': 'Kendaraan berhasil ditambahkan.',
        'data': newVehicle,
      });
    }

    return MockResponse.error('Not found: $path', statusCode: 404);
  }

  static Future<http.Response> _handlePut(
      String path, Map<String, dynamic> body) async {
    // PUT /users/profile
    if (path == '/users/profile') {
      final name = body['name'] as String? ?? '';
      final phoneNumber = body['phoneNumber'] as String? ?? '';

      final profile = await MockDatabase.getProfile();
      if (name.isNotEmpty) profile['name'] = name;
      if (phoneNumber.isNotEmpty) profile['phoneNumber'] = phoneNumber;
      await MockDatabase.saveProfile(profile);

      return MockResponse.ok({
        'success': true,
        'message': 'Profil berhasil diperbarui.',
      });
    }

    return MockResponse.error('Not found: $path', statusCode: 404);
  }

  static Future<http.Response> _handlePatch(
      String path, Map<String, dynamic> body) async {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    // PATCH /reservations/{id}/arrive
    if (path.contains('/arrive') && segments.length >= 3) {
      final reservationId = segments[1];
      final res = await MockDatabase.getActiveReservation();
      if (res != null && res['reservationId'] == reservationId) {
        res['status'] = 'active';
        await MockDatabase.saveActiveReservation(res);
      }
      return MockResponse.ok({
        'success': true,
        'message': 'Kedatangan berhasil dikonfirmasi.',
      });
    }

    // PATCH /reservations/{id}/complete
    if (path.contains('/complete') && segments.length >= 3) {
      final reservationId = segments[1];

      // Save to history
      final res = await MockDatabase.getActiveReservation();
      if (res != null) {
        final history = await MockDatabase.getHistory();
        history.insert(0, {
          'reservationId': reservationId,
          'ticketId': res['ticketId'] ?? '',
          'userId': 'USR-001',
          'slotId': res['slotId'] ?? '',
          'areaId': res['areaId'] ?? '',
          'slotName': res['slotName'] ?? '',
          'name': 'User',
          'plateNumber': 'B 1234 CD',
          'status': 'completed',
          'timestamps': {
            'created': res['startTime'] ?? DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
            'arrived': DateTime.now().subtract(const Duration(hours: 2, minutes: 50)).toIso8601String(),
            'completed': DateTime.now().toIso8601String(),
          },
          'history': [],
          'formattedDuration': '3 Jam',
        });
        await MockDatabase.saveHistory(history);
        await MockDatabase.clearActiveReservation();
        await MockDatabase.clearActiveTicket();
      }

      return MockResponse.ok({
        'success': true,
        'message': 'Sesi parkir berhasil diselesaikan.',
      });
    }

    // PATCH /reservations/{id}/cancel
    if (path.contains('/cancel') && segments.length >= 3) {
      await MockDatabase.clearActiveReservation();
      await MockDatabase.clearActiveTicket();
      return MockResponse.ok({
        'success': true,
        'message': 'Reservasi berhasil dibatalkan.',
      });
    }

    // PATCH /reservations/{id}/swap
    if (path.contains('/swap') && segments.length >= 3) {
      final newSlotId = body['newSlotId'] as String? ?? '';
      final res = await MockDatabase.getActiveReservation();
      if (res != null && newSlotId.isNotEmpty) {
        res['slotId'] = newSlotId;
        res['slotName'] = newSlotId.split('-').last;
        await MockDatabase.saveActiveReservation(res);
      }
      return MockResponse.ok({
        'success': true,
        'message': 'Slot parkir berhasil diganti.',
      });
    }

    return MockResponse.error('Not found: $path', statusCode: 404);
  }

  static Future<http.Response> _handleDelete(String path) async {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    // DELETE /users/vehicles/{plateNumber}
    if (path.contains('/users/vehicles') && segments.length >= 3) {
      final plateNumber = Uri.decodeComponent(segments[2]);
      final vehicles = await MockDatabase.getVehicles();
      vehicles.removeWhere((v) => v['plateNumber'] == plateNumber);
      await MockDatabase.saveVehicles(vehicles);
      return MockResponse.ok({
        'success': true,
        'message': 'Kendaraan berhasil dihapus.',
      });
    }

    return MockResponse.error('Not found: $path', statusCode: 404);
  }
}
