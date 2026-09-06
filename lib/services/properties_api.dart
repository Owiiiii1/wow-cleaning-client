import 'package:wow_cleaning/config/us_states.dart';
import 'package:wow_cleaning/services/api_client.dart';

class ClientPropertyItem {
  ClientPropertyItem({
    required this.id,
    required this.title,
    this.address,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.squareFootage,
    this.bedrooms,
    this.bathrooms,
    this.mainImageUrl,
  });

  final int id;
  final String title;
  final String? address;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final int? squareFootage;
  final int? bedrooms;
  final int? bathrooms;
  final String? mainImageUrl;

  bool get hasHousingParams =>
      (squareFootage ?? 0) > 0 && (bedrooms ?? 0) > 0 && (bathrooms ?? 0) > 0;

  String? get displayAddress => UsStates.format(
    line1: addressLine1,
    line2: addressLine2,
    city: city,
    state: state,
    postalCode: postalCode,
    fallback: address,
  );

  factory ClientPropertyItem.fromJson(Map<String, dynamic> json) {
    return ClientPropertyItem(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString(),
      addressLine1: json['address_line1']?.toString(),
      addressLine2: json['address_line2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postal_code']?.toString(),
      squareFootage: _asInt(json['square_footage']),
      bedrooms: _asInt(json['bedrooms']),
      bathrooms: _asInt(json['bathrooms']),
      mainImageUrl: json['main_image_url']?.toString(),
    );
  }
}

class ClientPropertyDetail {
  ClientPropertyDetail({
    required this.id,
    required this.title,
    this.address,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.squareFootage,
    this.bedrooms,
    this.bathrooms,
    this.description,
    this.entryInstructions,
    this.mainImageUrl,
    required this.additionalImageUrls,
  });

  final int id;
  final String title;
  final String? address;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final int? squareFootage;
  final int? bedrooms;
  final int? bathrooms;
  final String? description;
  final String? entryInstructions;
  final String? mainImageUrl;
  final List<String> additionalImageUrls;

  String? get displayAddress => UsStates.format(
    line1: addressLine1,
    line2: addressLine2,
    city: city,
    state: state,
    postalCode: postalCode,
    fallback: address,
  );

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
      addressLine1: json['address_line1']?.toString(),
      addressLine2: json['address_line2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postal_code']?.toString(),
      squareFootage: _asInt(json['square_footage']),
      bedrooms: _asInt(json['bedrooms']),
      bathrooms: _asInt(json['bathrooms']),
      description: json['description']?.toString(),
      entryInstructions: json['entry_instructions']?.toString(),
      mainImageUrl: json['main_image_url']?.toString(),
      additionalImageUrls: extras,
    );
  }
}

int? _asInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
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
    required int squareFootage,
    required int bedrooms,
    required int bathrooms,
    String? address,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? description,
    String? entryInstructions,
    String? mainImagePath,
    List<String> additionalImagePaths = const [],
  }) async {
    final extraFiles = <({String field, String path, String? filename})>[
      for (final path in additionalImagePaths)
        (field: 'additional_images[]', path: path, filename: null),
    ];

    final payload = await _client.postMultipart(
      'client/properties',
      fields: {
        'title': title,
        'square_footage': '$squareFootage',
        'bedrooms': '$bedrooms',
        'bathrooms': '$bathrooms',
        'address_line1': addressLine1 ?? '',
        'address_line2': addressLine2 ?? '',
        'city': city ?? '',
        'state': state ?? '',
        'postal_code': postalCode ?? '',
        'description': description ?? '',
        'entry_instructions': entryInstructions ?? '',
      },
      fileField: mainImagePath != null ? 'main_image' : null,
      filePath: mainImagePath,
      extraFiles: extraFiles,
    );

    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final property = data['property'] as Map<String, dynamic>? ?? {};
    return ClientPropertyDetail.fromJson(property);
  }

  Future<ClientPropertyDetail> update({
    required int id,
    required String title,
    required int squareFootage,
    required int bedrooms,
    required int bathrooms,
    String? address,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? description,
    String? entryInstructions,
    String? mainImagePath,
    List<String> additionalImagePaths = const [],
  }) async {
    final extraFiles = <({String field, String path, String? filename})>[
      for (final path in additionalImagePaths)
        (field: 'additional_images[]', path: path, filename: null),
    ];
    final hasFiles = mainImagePath != null || extraFiles.isNotEmpty;
    final Map<String, dynamic> payload;
    if (hasFiles) {
      payload = await _client.postMultipart(
        'client/properties/$id',
        fields: {
          'title': title,
          'square_footage': '$squareFootage',
          'bedrooms': '$bedrooms',
          'bathrooms': '$bathrooms',
          'address_line1': addressLine1 ?? '',
          'address_line2': addressLine2 ?? '',
          'city': city ?? '',
          'state': state ?? '',
          'postal_code': postalCode ?? '',
          'description': description ?? '',
          'entry_instructions': entryInstructions ?? '',
        },
        fileField: mainImagePath != null ? 'main_image' : null,
        filePath: mainImagePath,
        extraFiles: extraFiles,
      );
    } else {
      payload = await _client.patchJson('client/properties/$id', {
        'title': title,
        'square_footage': squareFootage,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'address_line1': addressLine1 ?? '',
        'address_line2': addressLine2 ?? '',
        'city': city ?? '',
        'state': state ?? '',
        'postal_code': postalCode ?? '',
        'description': description ?? '',
        'entry_instructions': entryInstructions ?? '',
      });
    }

    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final property = data['property'] as Map<String, dynamic>? ?? {};
    return ClientPropertyDetail.fromJson(property);
  }

  Future<void> delete(int id) async {
    await _client.deleteJson('client/properties/$id');
  }
}
