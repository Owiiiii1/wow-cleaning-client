import 'package:wow_cleaning/services/api_client.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.senderId,
    this.body,
    this.imageUrl,
    required this.isDeleted,
    required this.isEdited,
    this.editedAt,
    this.createdAt,
  });

  final int id;
  final int conversationId;
  final String senderType;
  final int senderId;
  final String? body;
  final String? imageUrl;
  final bool isDeleted;
  final bool isEdited;
  final String? editedAt;
  final String? createdAt;

  bool get isMine => senderType == 'client';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num?)?.toInt() ?? 0,
      senderType: json['sender_type']?.toString() ?? '',
      senderId: (json['sender_id'] as num?)?.toInt() ?? 0,
      body: json['body']?.toString(),
      imageUrl: json['image_url']?.toString(),
      isDeleted: json['is_deleted'] == true,
      isEdited: json['is_edited'] == true,
      editedAt: json['edited_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ChatThread {
  ChatThread({
    required this.conversationId,
    required this.unreadCount,
    required this.messages,
  });

  final int conversationId;
  final int unreadCount;
  final List<ChatMessage> messages;
}

class ChatApi {
  ChatApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<ChatThread> fetchChat() async {
    final payload = await _client.getJson('client/chat');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final raw = data['messages'];
    final messages = <ChatMessage>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          messages.add(ChatMessage.fromJson(item));
        }
      }
    }
    return ChatThread(
      conversationId: (data['conversation_id'] as num?)?.toInt() ?? 0,
      unreadCount: (data['unread_count'] as num?)?.toInt() ?? 0,
      messages: messages,
    );
  }

  Future<int> fetchUnreadCount() async {
    final payload = await _client.getJson('client/chat/unread');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return (data['unread_count'] as num?)?.toInt() ?? 0;
  }

  Future<ChatMessage> sendMessage({
    String? message,
    String? imagePath,
  }) async {
    final Map<String, dynamic> payload;
    if (imagePath != null) {
      payload = await _client.postMultipart(
        'client/chat/messages',
        fields: {
          if (message != null && message.trim().isNotEmpty)
            'message': message.trim(),
        },
        fileField: 'image',
        filePath: imagePath,
      );
    } else {
      payload = await _client.postJson('client/chat/messages', {
        'message': message?.trim() ?? '',
      });
    }

    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final msg = data['message'] as Map<String, dynamic>? ?? {};
    return ChatMessage.fromJson(msg);
  }

  Future<ChatMessage> editMessage(int id, String message) async {
    final payload = await _client.patchJson('client/chat/messages/$id', {
      'message': message.trim(),
    });
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final msg = data['message'] as Map<String, dynamic>? ?? {};
    return ChatMessage.fromJson(msg);
  }

  Future<ChatMessage> deleteMessage(int id) async {
    final payload = await _client.deleteJson('client/chat/messages/$id');
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    final msg = data['message'] as Map<String, dynamic>? ?? {};
    return ChatMessage.fromJson(msg);
  }
}
