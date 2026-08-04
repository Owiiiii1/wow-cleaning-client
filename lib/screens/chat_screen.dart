import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/chat_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.isActive,
    this.onUnreadCleared,
  });

  /// When false (IndexedStack off-tab), do not call /client/chat (mark-read).
  final bool isActive;
  final VoidCallback? onUnreadCleared;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApi _api = ChatApi();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<ChatMessage> _messages = [];
  bool _loading = true;
  bool _sending = false;
  String? _error;
  int? _editingId;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _activate();
    } else {
      _loading = false;
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _activate();
    } else if (!widget.isActive && oldWidget.isActive) {
      _deactivate();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _activate() {
    _load(initial: true);
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && widget.isActive) _load();
    });
  }

  void _deactivate() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _load({bool initial = false}) async {
    if (!widget.isActive) return;

    if (initial) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final thread = await _api.fetchChat();
      if (!mounted || !widget.isActive) return;
      setState(() {
        _messages = thread.messages.where((m) => !m.isDeleted).toList();
        _loading = false;
        _error = null;
      });
      widget.onUnreadCleared?.call();
      if (initial) {
        _scrollToBottom();
      }
    } on ApiException catch (e) {
      if (!mounted || !widget.isActive) return;
      setState(() {
        _loading = false;
        _error = e.displayMessage;
      });
    } catch (_) {
      if (!mounted || !widget.isActive) return;
      setState(() {
        _loading = false;
        _error = S.current.chatLoadFailed;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send({String? imagePath}) async {
    final text = _textController.text.trim();
    if (_sending) return;
    if (text.isEmpty && imagePath == null) return;

    if (_editingId != null) {
      await _saveEdit();
      return;
    }

    setState(() => _sending = true);
    try {
      await _api.sendMessage(message: text.isEmpty ? null : text, imagePath: imagePath);
      _textController.clear();
      await _load();
      _scrollToBottom();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.displayMessage)),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _saveEdit() async {
    final id = _editingId;
    final text = _textController.text.trim();
    if (id == null || text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      await _api.editMessage(id, text);
      _textController.clear();
      setState(() => _editingId = null);
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.displayMessage)),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null) return;
    await _send(imagePath: file.path);
  }

  void _startEdit(ChatMessage message) {
    setState(() {
      _editingId = message.id;
      _textController.text = message.body ?? '';
    });
  }

  Future<void> _delete(ChatMessage message) async {
    try {
      await _api.deleteMessage(message.id);
      if (!mounted) return;
      setState(() {
        _messages = _messages.where((m) => m.id != message.id).toList();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.displayMessage)),
      );
    }
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Column(
      children: [
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.pictonBlue))
              : _error != null && _messages.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: AppFonts.body(color: AppColors.darkGray),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      itemCount: _messages.where((m) => !m.isDeleted).length,
                      itemBuilder: (context, index) {
                        final visible = _messages.where((m) => !m.isDeleted).toList();
                        final msg = visible[index];
                        return _MessageBubble(
                          message: msg,
                          timeLabel: _formatTime(msg.createdAt),
                          editedLabel: s.chatEdited,
                          onEdit: msg.isMine && (msg.body?.isNotEmpty ?? false)
                              ? () => _startEdit(msg)
                              : null,
                          onDelete: msg.isMine ? () => _delete(msg) : null,
                        );
                      },
                    ),
        ),
        if (_editingId != null)
          Container(
            width: double.infinity,
            color: AppColors.pictonBlue.withValues(alpha: 0.12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    s.chatEditing,
                    style: AppFonts.body(color: AppColors.darkGray, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _editingId = null;
                      _textController.clear();
                    });
                  },
                  child: Text(s.cancel),
                ),
              ],
            ),
          ),
        // No SafeArea bottom — bottom nav already sits below this tab.
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          child: Row(
            children: [
              IconButton(
                onPressed: _sending || _editingId != null ? null : _pickImage,
                icon: const Icon(Icons.image_outlined, color: AppColors.darkGray),
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 4,
                  style: AppFonts.body(color: AppColors.darkGray),
                  decoration: InputDecoration(
                    hintText: s.chatHint,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: AppColors.darkGray.withValues(alpha: 0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: AppColors.darkGray.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: AppColors.pictonBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                onPressed: _sending ? null : () => _send(),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.pictonBlue,
                  foregroundColor: Colors.white,
                ),
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.timeLabel,
    required this.editedLabel,
    this.onEdit,
    this.onDelete,
  });

  final ChatMessage message;
  final String timeLabel;
  final String editedLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final bubbleColor = mine ? AppColors.pictonBlue : Colors.white;
    final textColor = mine ? Colors.white : AppColors.darkGray;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(mine ? 16 : 4),
              bottomRight: Radius.circular(mine ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.imageUrl != null &&
                            message.imageUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                message.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Text(
                                  'Image',
                                  style: AppFonts.body(color: textColor),
                                ),
                              ),
                            ),
                          ),
                        if ((message.body ?? '').isNotEmpty)
                          Text(
                            message.body!,
                            style: AppFonts.body(color: textColor, fontSize: 15),
                          ),
                      ],
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: textColor.withValues(alpha: 0.85),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') onEdit?.call();
                        if (value == 'delete') onDelete?.call();
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(S.current.chatEdit),
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(S.current.chatDelete),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isEdited) ...[
                    Text(
                      editedLabel,
                      style: AppFonts.body(
                        color: textColor.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    timeLabel,
                    style: AppFonts.body(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
