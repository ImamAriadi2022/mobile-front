import 'dart:convert';
import '../../../core/network/api_service.dart';

/// ProfileData — Model data profil pengguna.
class ProfileData {
  final String name;
  final String email;
  final String phoneNumber;

  ProfileData({required this.name, required this.email, required this.phoneNumber});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // Response dari GET /users/profile bisa langsung atau dibungkus {success, data: {...}}
    final Map<String, dynamic> src = (json['data'] is Map)
        ? json['data'] as Map<String, dynamic>
        : json;
    return ProfileData(
      name: src['name'] ?? 'User',
      email: src['email'] ?? 'No Email',
      phoneNumber: src['phoneNumber'] ?? 'No Phone Number',
    );
  }
}

/// ProfileService — Service layer profil pengguna.
///
/// Menangani GET /users/profile dan PUT /users/profile.
/// Untuk kendaraan, gunakan VehicleService.
class ProfileService {
  final ApiService _apiService = ApiService();

  Future<bool> updateProfile(String name, String email, String phoneNumber) async {
    try {
      final response = await _apiService.put(
        '/users/profile',
        body: {'name': name, 'email': email, 'phoneNumber': phoneNumber},
        requireAuth: true,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<ProfileData?> getProfile() async {
    try {
      final response = await _apiService.get('/users/profile', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }
}
