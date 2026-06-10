import 'dart:convert';
import '../../../core/network/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final token = body['data']?['token'];
        if (token != null) {
          await _apiService.setToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password, String plateNumber) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'password': password,
          'defaultLicensePlate': plateNumber,
          'vehicleType': 'mobil',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout', requireAuth: true);
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await _apiService.clearToken();
    }
  }
}
