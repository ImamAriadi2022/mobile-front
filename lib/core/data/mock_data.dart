import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MockDatabase {
  MockDatabase._();

  static const String _versionKey = 'mock_db_version';
  static const String _tokenKey = 'mock_jwt_token';
  static const String _roleKey = 'mock_user_role';
  static const String _profileKey = 'mock_profile';
  static const String _vehiclesKey = 'mock_vehicles';
  static const String _areasKey = 'mock_areas';
  static const String _slotsPrefix = 'mock_slots_';
  static const String _historyKey = 'mock_history';
  static const String _activeTicketKey = 'mock_active_ticket';
  static const String _activeReservationKey = 'mock_active_reservation';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt(_versionKey);
    if (version == null) {
      await _seed(prefs);
    }
  }

  static Future<void> _seed(SharedPreferences prefs) async {
    await prefs.setInt(_versionKey, 1);
    await prefs.setString(_tokenKey, 'mock_jwt_token_2024');
    await prefs.setString(_roleKey, 'user');
  }

  // ─── TOKEN ───────────────────────────────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ─── ROLE ────────────────────────────────────────────────────────────────────
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  static Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
  }

  // ─── PROFILE ─────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw != null) return jsonDecode(raw) as Map<String, dynamic>;
    return _defaultProfile();
  }

  static Future<void> saveProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile));
  }

  static Map<String, dynamic> _defaultProfile() {
    return {
      'userId': 'USR-001',
      'name': 'Budi Santoso',
      'email': 'budi@email.com',
      'phoneNumber': '081234567890',
      'photoUrl': null,
      'role': 'user',
      'vehicles': _defaultVehicles(),
    };
  }

  // ─── VEHICLES ────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_vehiclesKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return _defaultVehicles();
  }

  static Future<void> saveVehicles(List<Map<String, dynamic>> vehicles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vehiclesKey, jsonEncode(vehicles));
  }

  static List<Map<String, dynamic>> _defaultVehicles() {
    return [
      {'plateNumber': 'B 1234 CD', 'vehicleType': 'mobil'},
      {'plateNumber': 'D 5678 EF', 'vehicleType': 'motor'},
    ];
  }

  // ─── AREAS ───────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_areasKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return _defaultAreas();
  }

  static Future<void> saveAreas(List<Map<String, dynamic>> areas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_areasKey, jsonEncode(areas));
  }

  static List<Map<String, dynamic>> _defaultAreas() {
    return [
      {
        'id': 'area-001',
        'name': 'Teknik Elektro Universitas Lampung',
        'address': 'Jl. Prof. Dr. Ir. Sumantri Brojonegoro No.1',
        'totalSlots': 50,
        'availableSlots': 12,
      },
      {
        'id': 'area-002',
        'name': 'Gedung Rektorat Unila',
        'address': 'Jl. Prof. Dr. Ir. Sumantri Brojonegoro No.2',
        'totalSlots': 30,
        'availableSlots': 5,
      },
      {
        'id': 'area-003',
        'name': 'Fakultas Kedokteran Unila',
        'address': 'Jl. Prof. Dr. Ir. Sumantri Brojonegoro No.3',
        'totalSlots': 40,
        'availableSlots': 18,
      },
      {
        'id': 'area-004',
        'name': 'Gedung Serbaguna Unila',
        'address': 'Jl. Prof. Dr. Ir. Sumantri Brojonegoro No.4',
        'totalSlots': 25,
        'availableSlots': 0,
      },
      {
        'id': 'area-005',
        'name': 'Fakultas Hukum Unila',
        'address': 'Jl. Prof. Dr. Ir. Sumantri Brojonegoro No.5',
        'totalSlots': 35,
        'availableSlots': 8,
      },
    ];
  }

  // ─── SLOTS ───────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getSlots(String areaId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_slotsPrefix$areaId');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return _defaultSlots(areaId);
  }

  static Future<void> saveSlots(
      String areaId, List<Map<String, dynamic>> slots) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_slotsPrefix$areaId', jsonEncode(slots));
  }

  static List<Map<String, dynamic>> _defaultSlots(String areaId) {
    final zones = ['A', 'B', 'C', 'D'];
    final slots = <Map<String, dynamic>>[];
    var index = 0;
    for (final zone in zones) {
      for (var num = 1; num <= 12; num++) {
        index++;
        final statuses = [
          'available',
          'available',
          'available',
          'occupied',
          'booked',
          'available'
        ];
        final status = statuses[index % statuses.length];
        slots.add({
          'id': '$areaId-$zone$num',
          'slotName': '$zone$num',
          'slotNumber': '$zone$num',
          'status': status,
          'appStatus': status,
          'vehicleType': num % 3 == 0 ? 'motor' : 'mobil',
          'floor': zone,
        });
      }
    }
    return slots;
  }

  // ─── HISTORY ─────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return _defaultHistory();
  }

  static Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(history));
  }

  static List<Map<String, dynamic>> _defaultHistory() {
    final now = DateTime.now();
    return [
      {
        'reservationId': 'RSV-001',
        'ticketId': 'TXT-A1B2C3D4',
        'userId': 'USR-001',
        'slotId': 'area-001-A1',
        'areaId': 'area-001',
        'slotName': 'A1',
        'name': 'Budi Santoso',
        'plateNumber': 'B 1234 CD',
        'status': 'completed',
        'timestamps': {
          'created': now.subtract(const Duration(hours: 5)).toIso8601String(),
          'arrived': now
              .subtract(const Duration(hours: 4, minutes: 50))
              .toIso8601String(),
          'completed': now.subtract(const Duration(hours: 2)).toIso8601String(),
        },
        'history': [],
        'formattedDuration': '3 Jam',
      },
      {
        'reservationId': 'RSV-002',
        'ticketId': 'TXT-E5F6G7H8',
        'userId': 'USR-001',
        'slotId': 'area-002-B3',
        'areaId': 'area-002',
        'slotName': 'B3',
        'name': 'Budi Santoso',
        'plateNumber': 'B 1234 CD',
        'status': 'completed',
        'timestamps': {
          'created':
              now.subtract(const Duration(days: 1, hours: 3)).toIso8601String(),
          'arrived': now
              .subtract(const Duration(days: 1, hours: 2, minutes: 45))
              .toIso8601String(),
          'completed': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        'history': [],
        'formattedDuration': '2 Jam 30 Menit',
      },
      {
        'reservationId': 'RSV-003',
        'ticketId': 'TXT-I9J0K1L2',
        'userId': 'USR-001',
        'slotId': 'area-003-C5',
        'areaId': 'area-003',
        'slotName': 'C5',
        'name': 'Budi Santoso',
        'plateNumber': 'B 1234 CD',
        'status': 'cancelled',
        'timestamps': {
          'created':
              now.subtract(const Duration(days: 2, hours: 6)).toIso8601String(),
          'arrived': null,
          'completed': null,
        },
        'history': [],
        'formattedDuration': '-',
      },
      {
        'reservationId': 'RSV-004',
        'ticketId': 'TXT-M3N4O5P6',
        'userId': 'USR-001',
        'slotId': 'area-001-D2',
        'areaId': 'area-001',
        'slotName': 'D2',
        'name': 'Budi Santoso',
        'plateNumber': 'D 5678 EF',
        'status': 'completed',
        'timestamps': {
          'created':
              now.subtract(const Duration(days: 3, hours: 4)).toIso8601String(),
          'arrived': now
              .subtract(const Duration(days: 3, hours: 3, minutes: 50))
              .toIso8601String(),
          'completed':
              now.subtract(const Duration(days: 3, hours: 1)).toIso8601String(),
        },
        'history': [],
        'formattedDuration': '3 Jam',
      },
    ];
  }

  // ─── ACTIVE TICKET ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getActiveTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeTicketKey);
    if (raw != null) return jsonDecode(raw) as Map<String, dynamic>;
    return _defaultActiveTicket();
  }

  static Future<void> saveActiveTicket(Map<String, dynamic> ticket) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeTicketKey, jsonEncode(ticket));
  }

  static Future<void> clearActiveTicket() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeTicketKey);
  }

  static Map<String, dynamic>? _defaultActiveTicket() {
    return {
      'ticketId': 'TXT-ABCD1234',
      'ticketCode': 'TXT-ABCD1234',
      'id': 'TXT-ABCD1234',
      'code': 'TXT-ABCD1234',
      'status': 'active',
      'vehicleType': 'mobil',
      'areaId': 'area-001',
      'areaName': 'Teknik Elektro Universitas Lampung',
      'bindingId': 'bind-001',
      'claimedAt': DateTime.now()
          .subtract(const Duration(minutes: 30))
          .toIso8601String(),
    };
  }

  // ─── ACTIVE RESERVATION ─────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getActiveReservation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeReservationKey);
    if (raw != null) return jsonDecode(raw) as Map<String, dynamic>;
    return null;
  }

  static Future<void> saveActiveReservation(Map<String, dynamic> res) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeReservationKey, jsonEncode(res));
  }

  static Future<void> clearActiveReservation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeReservationKey);
  }

  // ─── CLEANUP ─────────────────────────────────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_profileKey);
    await prefs.remove(_vehiclesKey);
    await prefs.remove(_activeTicketKey);
    await prefs.remove(_activeReservationKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
