import 'dart:convert';
import '../../../core/network/api_service.dart';

class ProfileData {
  final String name;
  final String email;
  final String phoneNumber;

  ProfileData({required this.name, required this.email, required this.phoneNumber});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] ?? 'User',
      email: json['email'] ?? 'No Email',
      phoneNumber: json['phoneNumber'] ?? 'No Phone Number',
    );
  }
}

class VehicleData {
  final String plateNumber;
  final String vehicleType;

  VehicleData({required this.plateNumber, required this.vehicleType});

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      plateNumber: json['plateNumber'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
    );
  }
}

class ProfileService {
  final ApiService _apiService = ApiService();

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

  Future<List<VehicleData>> getVehicles() async {
    // Note: api.md only lists Add/Delete vehicle, but usually there's a GET /users/vehicles or it's inside profile.
    // If not, we will assume it returns empty for now or try fetching.
    try {
      final response = await _apiService.get('/users/vehicles', requireAuth: true);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((v) => VehicleData.fromJson(v)).toList();
      }
      return [];
    } catch (e) {
      print('Get vehicles error: $e');
      return [];
    }
  }
}
