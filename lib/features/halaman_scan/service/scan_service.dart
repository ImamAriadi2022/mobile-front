import 'dart:convert';
import '../../../core/network/api_service.dart';

class ScanService {
  final ApiService _apiService = ApiService();

  Future<bool> verifyTicket(String ticketId) async {
    try {
      final response = await _apiService.post(
        '/access/verify',
        body: {'ticketId': ticketId},
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Verify ticket error: $e');
      return false;
    }
  }
}
