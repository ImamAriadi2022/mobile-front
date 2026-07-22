import 'dart:convert';
import '../../../core/network/api_service.dart';
import '../models/ticket_data.dart';

/// ScanService — Service layer untuk verifikasi tiket QR.
///
/// Menangani POST /access/verify dan GET /access/activeTicket.
/// Model TicketData dipisahkan ke scan/models/ticket_data.dart.
///
/// Flow: ScanProvider → ScanService → REST API
class ScanService {
  final ApiService _api = ApiService();

  /// Verifikasi QR code tiket parkir.
  ///
  /// Mengirim [qrCode] ke POST /access/verify.
  /// Mengembalikan [TicketData] jika berhasil, null jika gagal.
  Future<TicketData?> verifyTicket(String qrCode) async {
    try {
      final response = await _api.post(
        '/access/verify',
        body: {'qrCode': qrCode},
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'];
        if (data != null) {
          return TicketData.fromJson(data as Map<String, dynamic>);
        }
        return TicketData.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Ambil tiket aktif yang sedang berjalan dari server.
  ///
  /// Mengembalikan [TicketData] jika ada tiket aktif, null jika tidak ada.
  Future<TicketData?> getActiveTicket() async {
    try {
      final response = await _api.get(
        '/access/activeTicket',
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'];
        final ticket = data != null
            ? TicketData.fromJson(data as Map<String, dynamic>)
            : TicketData.fromJson(json);

        return ticket.isValid ? ticket : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// AccessService — Alias backward-compatible untuk ScanService.
///
/// Widget lama memanggil `AccessService().getActiveTicket()`.
/// Digabung ke dalam ScanService sebagai satu service domain scan.
typedef AccessService = ScanService;
