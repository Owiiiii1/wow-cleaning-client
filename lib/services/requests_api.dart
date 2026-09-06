import 'package:wow_cleaning/services/api_client.dart';

class ClientRequest {
  ClientRequest({
    required this.id,
    required this.requestType,
    required this.message,
    required this.status,
    required this.publishedUpdates,
    required this.attachments,
    this.order,
    this.remediationOrder,
    this.resolutionCode,
    this.createdAt,
    this.completedAt,
    this.canOpenChat = false,
  });

  final int id;
  final String requestType;
  final String message;
  final String status;
  final List<RequestUpdate> publishedUpdates;
  final List<RequestAttachment> attachments;
  final RequestOrderSummary? order;
  final RequestOrderSummary? remediationOrder;
  final String? resolutionCode;
  final String? createdAt;
  final String? completedAt;
  final bool canOpenChat;

  bool get isCompleted =>
      completedAt != null ||
      const {'completed', 'resolved', 'closed'}.contains(status);

  factory ClientRequest.fromJson(Map<String, dynamic> json) {
    return ClientRequest(
      id: _asInt(json['id']),
      requestType: json['request_type']?.toString() ?? 'general_feedback',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'new',
      publishedUpdates: _mapList(
        json['published_updates'],
        RequestUpdate.fromJson,
      ),
      attachments: _mapList(json['attachments'], RequestAttachment.fromJson),
      order: _mapOrNull(json['order'], RequestOrderSummary.fromJson),
      remediationOrder: _mapOrNull(
        json['remediation_order'],
        RequestOrderSummary.fromJson,
      ),
      resolutionCode: json['resolution_code']?.toString(),
      createdAt: json['created_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
      canOpenChat:
          json['client_app_user'] is Map &&
          (json['client_app_user'] as Map)['client_cache_id'] != null,
    );
  }
}

class RequestUpdate {
  RequestUpdate({required this.message, this.createdAt});

  final String message;
  final String? createdAt;

  factory RequestUpdate.fromJson(Map<String, dynamic> json) => RequestUpdate(
    message:
        (json['message'] ?? json['body'] ?? json['text'])?.toString() ?? '',
    createdAt: json['created_at']?.toString(),
  );
}

class RequestAttachment {
  RequestAttachment({required this.url, this.name});

  final String url;
  final String? name;

  factory RequestAttachment.fromJson(Map<String, dynamic> json) =>
      RequestAttachment(
        url: (json['url'] ?? json['download_url'])?.toString() ?? '',
        name: (json['name'] ?? json['filename'])?.toString(),
      );
}

class RequestOrderSummary {
  RequestOrderSummary({
    required this.id,
    this.title,
    this.date,
    this.status,
    this.address,
  });

  final int id;
  final String? title;
  final String? date;
  final String? status;
  final String? address;

  factory RequestOrderSummary.fromJson(Map<String, dynamic> json) =>
      RequestOrderSummary(
        id: _asInt(json['id']),
        title: (json['service_name'] ?? json['title'])?.toString(),
        date: (json['date'] ?? json['scheduled_date'] ?? json['scheduled_at'])
            ?.toString(),
        status: json['status']?.toString(),
        address: json['address']?.toString(),
      );
}

class RequestsApi {
  RequestsApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<ClientRequest>> fetchRequests({String scope = 'active'}) async {
    final payload = await _client.getJson('client/requests?scope=$scope');
    final raw =
        payload['items'] ??
        (payload['data'] is Map ? (payload['data'] as Map)['items'] : null) ??
        payload['data'];
    return _mapList(raw, ClientRequest.fromJson);
  }

  Future<ClientRequest> fetchRequest(int id) async {
    final payload = await _client.getJson('client/requests/$id');
    final raw =
        payload['request'] ??
        (payload['data'] is Map
            ? ((payload['data'] as Map)['request'] ?? payload['data'])
            : null) ??
        payload;
    return ClientRequest.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<ClientRequest> createFeedback({
    required String message,
    List<String> photoPaths = const [],
  }) {
    return _create('client/requests', message: message, photoPaths: photoPaths);
  }

  Future<ClientRequest> createDispute({
    required int orderId,
    required String message,
    List<String> photoPaths = const [],
  }) {
    return _create(
      'client/orders/$orderId/dispute',
      message: message,
      photoPaths: photoPaths,
    );
  }

  Future<ClientRequest> _create(
    String path, {
    required String message,
    required List<String> photoPaths,
  }) async {
    final payload = await _client.postMultipart(
      path,
      fields: {'message': message.trim()},
      extraFiles: [
        for (final path in photoPaths)
          (field: 'photos[]', path: path, filename: null),
      ],
    );
    final raw =
        payload['request'] ??
        (payload['data'] is Map
            ? ((payload['data'] as Map)['request'] ?? payload['data'])
            : null) ??
        payload;
    return ClientRequest.fromJson(Map<String, dynamic>.from(raw as Map));
  }
}

int _asInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;

T? _mapOrNull<T>(dynamic raw, T Function(Map<String, dynamic>) builder) {
  if (raw is! Map) return null;
  return builder(Map<String, dynamic>.from(raw));
}

List<T> _mapList<T>(dynamic raw, T Function(Map<String, dynamic>) builder) {
  if (raw is! List) return <T>[];
  return raw
      .whereType<Map>()
      .map((item) => builder(Map<String, dynamic>.from(item)))
      .toList();
}
