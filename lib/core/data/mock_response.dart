import 'dart:convert';
import 'package:http/http.dart' as http;

class MockResponse {
  static http.Response ok(Map<String, dynamic> body) {
    return http.Response(jsonEncode(body), 200, headers: _jsonHeaders);
  }

  static http.Response okWithData(Map<String, dynamic> data,
      {String message = 'Success'}) {
    return ok({'success': true, 'message': message, 'data': data});
  }

  static http.Response okList(List<dynamic> data,
      {String message = 'Success'}) {
    return http.Response(
        jsonEncode({'success': true, 'message': message, 'data': data}), 200,
        headers: _jsonHeaders);
  }

  static http.Response created(Map<String, dynamic> body) {
    return http.Response(jsonEncode(body), 201, headers: _jsonHeaders);
  }

  static http.Response error(String message,
      {int statusCode = 400, bool success = false}) {
    return http.Response(
        jsonEncode({'success': success, 'message': message}), statusCode,
        headers: _jsonHeaders);
  }

  static http.Response serverError() {
    return error('Internal Server Error', statusCode: 500);
  }

  static final Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
