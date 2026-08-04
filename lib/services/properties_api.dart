import 'package:wow_cleaning/services/api_client.dart';

class ClientPropertyItem {
  ClientPropertyItem({
    required this.id,
    required this.title,
    this.address,
    this.mainImageUrl,
  });

  final int id;
  final String title;
  final String? address;
  final String? mainImageUrl;

  factory ClientPropertyItem.fromJson(Map<String, dynamic> json) {
    return ClientPropertyItem(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString(),
      mainImageUrl: json['main_image_url']?.toString(),
    );
  }
}

class ClientPropertyDetail {
  ClientPropertyDetail({
    required this.id,
    required this.title,
    this.address,
    this.description,
    this.entryInstructions,
    this.mainImageUrl,
    required this.additionalImageUrls,
  });

  final int id;
  final String title;
  final String? address;
  final String? description;
  final String? entryInstructions;
  final String? mainImageUrl;
  final List<String> additionalImageUrls;

  factory ClientPropertyDetail.fromJson(Map<String, dynamic> json) {
    final extras = <String>[];
    final raw = json['additional_images'];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map && item['image_url'] != null) {
          extras.add(item['image_url'].toString());
        }
      }
    }
    return ClientPropertyDetail(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString(),
      description: json['description']?.toString(),
      entryInstructions: json['entry_instructions']?.toString(),
      mainImageUrl: json['main_image_url']?.toString(),
      additionalImageUrls: extras,
    );
  }
}

class PropertiesApi {
  PropertiesApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<ClientPropertyItem>> list() async {
    final payload = await _client.getJson('client/properties');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final raw = data['items'];
    final items = <ClientPropertyItem>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          items.add(ClientPropertyItem.fromJson(item));
        }
      }
    }
    return items;
  }

  Future<ClientPropertyDetail> show(int id) async {
    final payload = await _client.getJson('client/properties/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final property = data['property'] as Map<String, dynamic>? ?? {};
    return ClientPropertyDetail.fromJson(property);
  }

  Future<ClientPropertyDetail> create({
    required String title,
    String? address,
    String? description,
    String? entryInstructions,
    String? mainImagePath,
    List<String> additionalImagePaths = const [],
  }) async {
    final extraFiles =
        <({String field, String path, String? filename})>[
      for (final path in additionalImagePaths)
        (field: 'additional_images[]', path: path, filename: null),
    ];

    final payload = await _client.postMultipart(
      'client/properties',
      fields: {
        'title': title,
        if (address != null) 'address': address,
        if (description != null) 'description': description,
        if (entryInstructions != null) 'entry_instructions': entryInstructions,
      },
      fileField: mainImagePath != null ? 'main_image' : null,
      filePath: mainImagePath,
      extraFiles: extraFiles,
    );

    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final property = data['property'] as Map<String, dynamic>? ?? {};
    return ClientPropertyDetail.fromJson(property);
  }
}
