import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/services/session_store.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.errors});

  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  @override
  String toString() => message;

  String get displayMessage {
    if (errors == null || errors!.isEmpty) return message;
    final parts = <String>[];
    errors!.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        parts.add(value.first.toString());
      } else if (value != null) {
        parts.add(value.toString());
      }
    });
    if (parts.isEmpty) return message;
    return parts.join('\n');
  }
}

class ApiClient {
  ApiClient({http.Client? client, this.timeout = const Duration(seconds: 20)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Uri _uri(String path) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${AppConfig.apiBaseUrl}/$normalized');
  }

  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = SessionStore.instance.token;
    if (auth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    try {
      final response = await _client
          .post(
            _uri(path),
            headers: _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _decode(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw ApiException('Network error: ${error.message}');
    }
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    bool auth = true,
  }) async {
    try {
      final response = await _client
          .get(
            _uri(path),
            headers: _headers(auth: auth),
          )
          .timeout(timeout);

      return _decode(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw ApiException('Network error: ${error.message}');
    }
  }

  Future<Map<String, dynamic>> patchJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    try {
      final response = await _client
          .patch(
            _uri(path),
            headers: _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _decode(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw ApiException('Network error: ${error.message}');
    }
  }

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    bool auth = true,
  }) async {
    try {
      final response = await _client
          .delete(
            _uri(path),
            headers: _headers(auth: auth),
          )
          .timeout(timeout);

      return _decode(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw ApiException('Network error: ${error.message}');
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    String? fileField,
    String? filePath,
    String? filename,
    List<({String field, String path, String? filename})> extraFiles =
        const [],
    bool auth = true,
  }) async {
    try {
      final request = http.MultipartRequest('POST', _uri(path));
      final headers = _headers(auth: auth)..remove('Content-Type');
      request.headers.addAll(headers);
      request.fields.addAll(fields);
      if (fileField != null && filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileField,
            filePath,
            filename: filename,
          ),
        );
      }
      for (final file in extraFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            file.field,
            file.path,
            filename: file.filename,
          ),
        );
      }

      final streamed = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      return _decode(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw ApiException('Network error: ${error.message}');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      } else {
        throw ApiException(
          'Unexpected response format',
          statusCode: response.statusCode,
        );
      }
    } on FormatException {
      throw ApiException(
        'Invalid JSON from server (HTTP ${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    final errors = payload['errors'];
    throw ApiException(
      payload['message']?.toString() ??
          'Request failed (HTTP ${response.statusCode})',
      statusCode: response.statusCode,
      errors: errors is Map<String, dynamic> ? errors : null,
    );
  }
}
