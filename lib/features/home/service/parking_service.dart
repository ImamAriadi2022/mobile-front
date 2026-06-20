import 'dart:convert';
import '../../../core/network/api_service.dart';

class ParkingService {
  final ApiService _apiService = ApiService();

  Future<CancelResult> cancelTicket(String ticketId) async {
    try {
      final response = await _apiService.post(
        '/access/cancelTicket',
        body: {'ticketId': ticketId},
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return CancelResult(success: true, message: json['message'] ?? 'Tiket berhasil dibatalkan.');
        }
        return CancelResult(success: false, message: json['message'] ?? 'Gagal membatalkan tiket.');
      }
      return CancelResult(success: false, message: 'Gagal terhubung ke server.');
    } catch (e) {
      return CancelResult(success: false, message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<CancelResult> cancelReservation(String reservationId) async {
    try {
      final response = await _apiService.patch(
        '/reservations/$reservationId/cancel',
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return CancelResult(success: true, message: json['message'] ?? 'Reservasi berhasil dibatalkan.');
        }
        return CancelResult(success: false, message: json['message'] ?? 'Gagal membatalkan reservasi.');
      }
      try {
        final json = jsonDecode(response.body);
        return CancelResult(success: false, message: json['message'] ?? 'Gagal terhubung ke server.');
      } catch (_) {
        return CancelResult(success: false, message: 'Gagal terhubung ke server (Status ${response.statusCode}).');
      }
    } catch (e) {
      return CancelResult(success: false, message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ActionResult> arriveReservation(String reservationId) async {
    try {
      final response = await _apiService.patch(
        '/reservations/$reservationId/arrive',
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final json = jsonDecode(response.body);
          return ActionResult(
            success: json['success'] == true,
            message: json['message'] ?? 'Kedatangan berhasil dikonfirmasi.',
          );
        } catch (_) {
          return ActionResult(success: true, message: 'Kedatangan berhasil dikonfirmasi.');
        }
      }
      try {
        final json = jsonDecode(response.body);
        return ActionResult(
          success: false,
          message: json['message'] ?? 'Gagal mengonfirmasi kedatangan.',
        );
      } catch (_) {
        return ActionResult(
          success: false,
          message: 'Gagal mengonfirmasi kedatangan (Status ${response.statusCode}).',
        );
      }
    } catch (e) {
      return ActionResult(success: false, message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ActionResult> completeReservation(String reservationId) async {
    try {
      final response = await _apiService.post(
        '/reservations/$reservationId/complete',
        body: {},
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final json = jsonDecode(response.body);
          return ActionResult(
            success: json['success'] == true,
            message: json['message'] ?? 'Sesi parkir berhasil diselesaikan.',
          );
        } catch (_) {
          return ActionResult(success: true, message: 'Sesi parkir berhasil diselesaikan.');
        }
      }
      try {
        final json = jsonDecode(response.body);
        return ActionResult(
          success: false,
          message: json['message'] ?? 'Gagal menyelesaikan sesi parkir.',
        );
      } catch (_) {
        return ActionResult(
          success: false,
          message: 'Gagal menyelesaikan sesi parkir (Status ${response.statusCode}).',
        );
      }
    } catch (e) {
      return ActionResult(success: false, message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ActionResult> swapReservation(String reservationId, String newSlotId) async {
    try {
      var response = await _apiService.patch(
        '/reservations/$reservationId/swap',
        body: {'newSlotId': newSlotId},
        requireAuth: true,
      );

      if (response.statusCode == 404 || response.statusCode == 405) {
        response = await _apiService.post(
          '/reservations/$reservationId/swap',
          body: {'newSlotId': newSlotId},
          requireAuth: true,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final json = jsonDecode(response.body);
          return ActionResult(
            success: json['success'] == true,
            message: json['message'] ?? 'Slot parkir berhasil diganti.',
          );
        } catch (_) {
          return ActionResult(success: true, message: 'Slot parkir berhasil diganti.');
        }
      }
      try {
        final json = jsonDecode(response.body);
        return ActionResult(
          success: false,
          message: json['message'] ?? 'Gagal mengganti slot parkir.',
        );
      } catch (_) {
        return ActionResult(
          success: false,
          message: 'Gagal mengganti slot parkir (Status ${response.statusCode}).',
        );
      }
    } catch (e) {
      return ActionResult(success: false, message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }
}

class CancelResult {
  final bool success;
  final String message;

  CancelResult({required this.success, required this.message});
}

class ActionResult {
  final bool success;
  final String message;

  ActionResult({required this.success, required this.message});
}
