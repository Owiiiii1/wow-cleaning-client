import 'package:wow_cleaning/services/api_client.dart';

class CleaningServiceItem {
  CleaningServiceItem({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String? description;
  final String? imageUrl;

  factory CleaningServiceItem.fromJson(Map<String, dynamic> json) {
    return CleaningServiceItem(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class ServicesApi {
  ServicesApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<CleaningServiceItem>> list() async {
    final payload = await _client.getJson('client/services');
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
