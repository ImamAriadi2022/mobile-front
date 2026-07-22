import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../storage/token_storage.dart';
import '../data/mock_router.dart';
import '../data/mock_data.dart';
import '../data/mock_response.dart';

/// ApiClient — HTTP client terpusat untuk REST API ParkFinder.
///
/// Bertanggung jawab HANYA untuk komunikasi HTTP.
/// Token management didelegasikan ke [TokenStorage].
/// Semua feature service menggunakan class ini sebagai base HTTP layer.
///
/// Saat [AppConfig.useMock] = true, semua request dialihkan ke
/// [MockRouter] yang membaca/menulis dari [MockDatabase] (SharedPreferences).
/// Tidak ada koneksi HTTP nyata — aplikasi berjalan offline dengan data statis.
///
/// Saat [AppConfig.useMock] = false, request dikirim ke backend sungguhan.
class ApiClient {
  final TokenStorage _tokenStorage = TokenStorage();

  // Singleton agar tidak ada duplikasi instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _tokenStorage.load();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockRouter.handle(method: 'GET', endpoint: endpoint);
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    return http.get(url, headers: headers);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockRouter.handle(
          method: 'POST', endpoint: endpoint, body: body);
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    return http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockRouter.handle(
          method: 'PUT', endpoint: endpoint, body: body);
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    return http.put(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockRouter.handle(
          method: 'PATCH', endpoint: endpoint, body: body);
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    return http.patch(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockRouter.handle(method: 'DELETE', endpoint: endpoint);
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    return http.delete(url, headers: headers);
  }

  Future<http.Response> multipartPost(
    String endpoint, {
    required List<int> fileBytes,
    required String fileName,
    String fieldName = 'image',
    bool requireAuth = false,
  }) async {
    if (AppConfig.useMock) {
      return MockResponse.ok({
        'success': true,
        'message': 'Foto profil berhasil diunggah (mock).',
        'data': {
          'photoUrl':
              'https://storage.googleapis.com/parkfinderbucket/foto/mock-avatar.png',
        },
      });
    }
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);

    if (requireAuth) {
      final token = await _tokenStorage.load();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    request.headers['Accept'] = 'application/json';

    request.files.add(
      http.MultipartFile.fromBytes(
        fieldName,
        fileBytes,
        filename: fileName,
      ),
    );

    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }
}

/// ApiService — Alias backward-compatible untuk ApiClient.
///
/// Disediakan agar service-service lama yang masih menggunakan `ApiService`
/// tidak perlu diubah sekaligus. Secara bertahap semua import akan diganti ke ApiClient.
///
/// @deprecated Gunakan [ApiClient] secara langsung.
typedef ApiService = ApiClient;
