import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../services/auth_storage.dart';

class ApiClient {
  ApiClient({
    required AuthStorage storage,
    http.Client? httpClient,
  })  : _storage = storage,
        _httpClient = httpClient ?? http.Client();

  final AuthStorage _storage;
  final http.Client _httpClient;

  Future<ApiClientResponse> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(path);
    final headers = await _headers();
    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _toResponse(response);
  }

  Future<ApiClientResponse> get(String path) async {
    final uri = _buildUri(path);
    final headers = await _headers();
    final response = await _httpClient.get(uri, headers: headers);
    return _toResponse(response);
  }

  Future<ApiClientResponse> delete(String path) async {
    final uri = _buildUri(path);
    final headers = await _headers();
    final response = await _httpClient.delete(uri, headers: headers);
    return _toResponse(response);
  }

  Uri _buildUri(String path) {
    return Uri.parse('${AppConfig.baseUrl}$path');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  ApiClientResponse _toResponse(http.Response response) {
    dynamic data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }
    }
    return ApiClientResponse(
      statusCode: response.statusCode,
      data: data,
    );
  }
}

class ApiClientResponse {
  const ApiClientResponse({
    required this.statusCode,
    this.data,
  });

  final int statusCode;
  final dynamic data;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
