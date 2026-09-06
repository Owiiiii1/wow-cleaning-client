import 'package:wow_cleaning/services/api_client.dart';

class VersionCheckResult {
  VersionCheckResult({
    required this.allowed,
    required this.updateRequired,
    this.storeUrl,
  });

  final bool allowed;
  final bool updateRequired;
  final String? storeUrl;

  factory VersionCheckResult.fromJson(Map<String, dynamic> json) {
    final url = json['store_url']?.toString().trim();
    return VersionCheckResult(
      allowed: json['allowed'] == true,
      updateRequired: json['update_required'] == true,
      storeUrl: (url == null || url.isEmpty) ? null : url,
    );
  }
}

class VersionCheckApi {
  VersionCheckApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<VersionCheckResult> check({
    required String audience,
    required String platform,
    required String version,
  }) async {
    final payload = await _client.getJson(
      'app/version-check?audience=$audience&platform=$platform&version=$version',
      auth: false,
    );
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return VersionCheckResult.fromJson(data);
  }
}
