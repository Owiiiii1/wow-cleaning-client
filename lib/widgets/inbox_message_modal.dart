import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/services/payment_action_service.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/branded_button.dart';
import 'package:wow_cleaning/widgets/inbox_reminder_actions.dart';

class InboxMessageModal extends StatefulWidget {
  const InboxMessageModal({super.key, required this.message});

  final InboxMessage message;

  @override
  State<InboxMessageModal> createState() => _InboxMessageModalState();
}

class _InboxMessageModalState extends State<InboxMessageModal> {
  final InboxApi _api = InboxApi();
  final PaymentActionService _payments = PaymentActionService();
  bool _saving = false;
  String? _error;

  Future<void> _markRead() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _api.markRead(widget.message.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.inboxMarkFailed;
      });
    }
  }

  Future<void> _reminderAction(String action) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _api.reminderAction(widget.message.id, action);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.inboxActionFailed;
      });
    }
  }

  Future<void> _paymentAction() async {
    final orderId = widget.message.orderId;
    if (_saving || orderId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _payments.confirm(orderId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.inboxActionFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final title = (widget.message.title ?? '').trim();
    final reminder = widget.message.hasReminderActions;
    final payment = widget.message.hasPaymentAction;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title.isNotEmpty ? title : s.inboxMessage,
                style: AppFonts.headline(
                  fontSize: 18,
                  color: AppColors.darkLiver,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: SingleChildScrollView(
                  child: Text(
                    widget.message.body,
                    style: AppFonts.body(
                      fontSize: 15,
                      color: AppColors.darkLiver,
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: AppFonts.body(
                    fontSize: 13,
                    color: const Color(0xFFE53935),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (payment)
                BrandedButton(
                  label: s.payNow,
                  loading: _saving,
                  onPressed: _paymentAction,
                )
              else if (reminder)
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
          ),
        ),
      ),
    );
  }
}
