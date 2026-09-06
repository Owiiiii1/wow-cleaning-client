import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/services/payment_action_service.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/branded_button.dart';
import 'package:wow_cleaning/widgets/inbox_reminder_actions.dart';

class InboxDetailScreen extends StatefulWidget {
  const InboxDetailScreen({super.key, required this.messageId});

  final int messageId;

  @override
  State<InboxDetailScreen> createState() => _InboxDetailScreenState();
}

class _InboxDetailScreenState extends State<InboxDetailScreen> {
  final InboxApi _api = InboxApi();
  final PaymentActionService _payments = PaymentActionService();
  InboxMessage? _item;
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String? _markError;

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
      final item = await _api.fetchMessage(widget.messageId);
      if (!mounted) return;
      setState(() {
        _item = item;
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

  Future<void> _markRead() async {
    final item = _item;
    if (item == null || _saving || !item.isUnread) {
      return;
    }
    setState(() {
      _saving = true;
      _markError = null;
    });
    try {
      final updated = await _api.markRead(item.id);
      if (!mounted) return;
      setState(() {
        _item = updated;
        _saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _markError = S.current.inboxMarkFailed;
      });
    }
  }

  Future<void> _reminderAction(String action) async {
    final item = _item;
    if (item == null || _saving) {
      return;
    }
    setState(() {
      _saving = true;
      _markError = null;
    });
    try {
      final updated = await _api.reminderAction(item.id, action);
      if (!mounted) return;
      setState(() {
        _item = updated;
        _saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _markError = S.current.inboxActionFailed;
      });
    }
  }

  Future<void> _paymentAction() async {
    final item = _item;
    if (item == null || item.orderId == null || _saving) return;
    setState(() {
      _saving = true;
      _markError = null;
    });
    try {
      await _payments.confirm(item.orderId!);
      await _load();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _markError = S.current.inboxActionFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final item = _item;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          item?.title ?? s.inboxMessage,
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
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowShadow,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    item?.body ?? '',
                    style: AppFonts.body(
                      fontSize: 15,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
                if (item != null &&
                    (item.hasPaymentAction ||
                        item.hasReminderActions ||
                        item.isUnread)) ...[
                  if (_markError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _markError!,
                      style: AppFonts.body(
                        fontSize: 13,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (item.hasPaymentAction)
                    BrandedButton(
                      label: s.payNow,
                      loading: _saving,
                      onPressed: _paymentAction,
                    )
                  else if (item.hasReminderActions)
                    InboxReminderActions(
                      loading: _saving,
                      onConfirm: () => _reminderAction('confirm'),
                      onPostpone: () => _reminderAction('postpone'),
                      onDecline: () => _reminderAction('decline'),
                    )
                  else
                    BrandedButton(
                      label: s.inboxRead,
                      loading: _saving,
                      onPressed: _markRead,
                    ),
                ],
              ],
            ),
    );
  }
}
