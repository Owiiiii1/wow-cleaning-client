import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/inbox_detail_screen.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class InboxListScreen extends StatefulWidget {
  const InboxListScreen({super.key});

  @override
  State<InboxListScreen> createState() => _InboxListScreenState();
}

class _InboxListScreenState extends State<InboxListScreen> {
  final InboxApi _api = InboxApi();
  List<InboxMessage> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _api.fetchMessages();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.inboxLoadFailed;
      });
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      final dt = DateTime.parse(value).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year}';
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          s.inboxTitle,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pictonBlue),
            )
          : _error != null
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
              : _items.isEmpty
                  ? Center(
                      child: Text(
                        s.inboxEmpty,
                        style: AppFonts.body(
                          color: AppColors.darkGray.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      InboxDetailScreen(messageId: item.id),
                                ),
                              );
                              if (mounted) _load();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (item.title ?? '').trim().isNotEmpty
                                              ? item.title!
                                              : s.inboxMessage,
                                          style: AppFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.darkGray,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.body,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFonts.body(
                                            fontSize: 13,
                                            color: AppColors.darkGray
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        if (_formatDate(item.createdAt)
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            _formatDate(item.createdAt),
                                            style: AppFonts.body(
                                              fontSize: 11,
                                              color: AppColors.darkGray
                                                  .withValues(alpha: 0.4),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (item.isUnread)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow
                                            .withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        s.inboxNew,
                                        style: AppFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkGray,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
