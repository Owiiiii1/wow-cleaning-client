import 'package:wow_cleaning/services/api_client.dart';

class CleaningServiceItem {
  CleaningServiceItem({
    required this.id,
    required this.title,
    this.code,
    this.kind,
    this.description,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String? code;
  final String? kind;
  final String? description;
  final String? imageUrl;

  bool get isWindowCleaning => code == 'window_cleaning';

  factory CleaningServiceItem.fromJson(Map<String, dynamic> json) {
    return CleaningServiceItem(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      code: json['code']?.toString(),
      kind: json['kind']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class ServicesApi {
  ServicesApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<CleaningServiceItem>> list({String kind = 'main'}) async {
    final payload = await _client.getJson('client/services?kind=$kind');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final raw = data['items'];
    final items = <CleaningServiceItem>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          items.add(CleaningServiceItem.fromJson(item));
        }
      }
    }
    return items;
  }
}
