import 'dart:convert';
import '../../../core/network/api_service.dart';

class TicketData {
  final String ticketCode;
  final String status;
  final String vehicleType;
  final String areaId;
  final String areaName;
  final String bindingId;
  final String claimedAt;

  TicketData({
    required this.ticketCode,
    required this.status,
    this.vehicleType = '',
    this.areaId = '',
    this.areaName = '',
    this.bindingId = '',
    this.claimedAt = '',
  });

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

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketCode,
      'id': ticketCode,
      'status': status,
      'vehicleType': vehicleType,
      'areaId': areaId,
      'areaName': areaName,
      'bindingId': bindingId,
      'claimedAt': claimedAt,
    };
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
