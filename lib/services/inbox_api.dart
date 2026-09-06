import 'package:wow_cleaning/services/api_client.dart';

class InboxMessage {
  InboxMessage({
    required this.id,
    this.title,
    required this.body,
    required this.isUnread,
    this.createdAt,
    this.readAt,
    this.kind,
    this.actions = const [],
    this.reminderStatus,
    this.orderId,
    this.actionRequiredBy,
  });

  final int id;
  final String? title;
  final String body;
  final bool isUnread;
  final String? createdAt;
  final String? readAt;
  final String? kind;
  final List<String> actions;
  final String? reminderStatus;
  final int? orderId;
  final String? actionRequiredBy;

  bool get hasReminderActions =>
      actions.isNotEmpty && kind == 'cleaning_reminder';

  bool get isFinishedRating => kind == 'order_finished';
  bool get hasPaymentAction =>
      kind == 'payment_action_required' &&
      actions.contains('pay') &&
      orderId != null;

  factory InboxMessage.fromJson(Map<String, dynamic> json) {
    final actions = <String>[];
    final rawActions = json['actions'];
    if (rawActions is List) {
      for (final item in rawActions) {
        final value = item?.toString();
        if (value != null && value.isNotEmpty) {
          actions.add(value);
        }
      }
    }

    return InboxMessage(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString(),
      body: json['body']?.toString() ?? '',
      isUnread: json['is_unread'] == true,
      createdAt: json['created_at']?.toString(),
      readAt: json['read_at']?.toString(),
      kind: json['kind']?.toString(),
      actions: actions,
      reminderStatus: json['reminder_status']?.toString(),
      orderId: (json['order_id'] as num?)?.toInt(),
      actionRequiredBy: json['action_required_by']?.toString(),
    );
  }
}

class InboxUnreadSnapshot {
  InboxUnreadSnapshot({required this.count, required this.items});

  final int count;
  final List<InboxMessage> items;
}

class InboxApi {
  InboxApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  List<InboxMessage> _parseItems(dynamic raw) {
    final items = <InboxMessage>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          items.add(InboxMessage.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
    return items;
  }

  Future<List<InboxMessage>> fetchMessages() async {
    final payload = await _client.getJson('client/inbox');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return _parseItems(data['items']);
  }

  Future<int> fetchUnreadCount() async {
    final snapshot = await fetchUnread();
    return snapshot.count;
  }

  Future<InboxUnreadSnapshot> fetchUnread() async {
    final payload = await _client.getJson('client/inbox/unread');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final items = _parseItems(data['items']);
    return InboxUnreadSnapshot(
      count: (data['unread_count'] as num?)?.toInt() ?? items.length,
      items: items,
    );
  }

  Future<InboxMessage> fetchMessage(int id) async {
    final payload = await _client.getJson('client/inbox/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return InboxMessage.fromJson(data);
  }

  Future<InboxMessage> markRead(int id) async {
    final payload = await _client.postJson('client/inbox/$id/read', {});
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return InboxMessage.fromJson(data);
  }

  Future<InboxMessage> reminderAction(int id, String action) async {
    final payload = await _client.postJson('client/inbox/$id/reminder-action', {
      'action': action,
    });
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return InboxMessage.fromJson(data);
  }

  Future<InboxMessage> rateMessage(int id, int rating) async {
    final payload = await _client.postJson('client/inbox/$id/rate', {
      'rating': rating,
    });
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return InboxMessage.fromJson(data);
  }

  Future<void> submitSurvey(
    int id, {
    required int cleaningQuality,
    required int punctuality,
    required int communication,
    required int serviceConvenience,
    String? improvementComment,
  }) async {
    await _client.postJson('client/inbox/$id/survey', {
      'cleaning_quality': cleaningQuality,
      'punctuality': punctuality,
      'communication': communication,
      'service_convenience': serviceConvenience,
      if (improvementComment != null && improvementComment.trim().isNotEmpty)
        'improvement_comment': improvementComment.trim(),
    });
  }

  Future<void> syncLocale(String locale) async {
    await _client.patchJson('client/profile', {'locale': locale});
  }
}
