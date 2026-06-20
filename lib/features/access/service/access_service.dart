import 'dart:convert';
import '../../../core/network/api_service.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../welcome_scan/service/scan_service.dart';

class AccessService {
  final ApiService _apiService = ApiService();

  Future<TicketData?> getActiveTicket() async {
    try {
      final response = await _apiService.get(
        '/access/activeTicket',
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final ticket = json['data'] != null
            ? TicketData.fromJson(json['data'])
            : TicketData.fromJson(json);
        
        if (ticket.ticketCode.isNotEmpty) {
          return ticket;
        }
      } else if (response.statusCode == 404) {
        // Server explicitly says no active ticket exists, sync local storage
        await ActiveTicketStorage().clear();
      }
      return null;
    } catch (e) {
      print('Get active ticket error: $e');
      return null;
    }
  }
}
