import 'dart:convert';
import '../../../core/network/api_service.dart';

class TicketData {
  final String ticketCode;
  final String status;

  TicketData({required this.ticketCode, required this.status});

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketCode: json['ticketCode'] ?? json['ticketId'] ?? json['code'] ?? '',
      status: json['status'] ?? 'active',
    );
  }
}

class ScanService {
  final ApiService _apiService = ApiService();

  Future<TicketData?> verifyTicket(String qrCode) async {
    try {
      final response = await _apiService.post(
        '/access/verify',
        body: {'qrCode': qrCode},
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null) {
          return TicketData.fromJson(json['data']);
        }
        return TicketData.fromJson(json);
      }
      return null;
    } catch (e) {
      print('Verify ticket error: $e');
      return null;
    }
  }
}
