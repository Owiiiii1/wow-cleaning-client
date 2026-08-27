import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class OrderFinishedModal extends StatefulWidget {
  const OrderFinishedModal({
    super.key,
    required this.message,
  });

  final InboxMessage message;

  @override
  State<OrderFinishedModal> createState() => _OrderFinishedModalState();
}

class _OrderFinishedModalState extends State<OrderFinishedModal> {
  final InboxApi _api = InboxApi();
  int? _hovered;
  bool _saving = false;
  String? _error;

  Future<void> _rate(int rating) async {
    if (_saving) return;
    setState(() {
      _hovered = rating;
      _saving = true;
      _error = null;
    });
    try {
      await _api.rateMessage(widget.message.id, rating);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.ratingSubmitFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.pictonBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 36,
                  color: AppColors.pictonBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.orderFinishedTitle,
                textAlign: TextAlign.center,
                style: AppFonts.headline(
                  fontSize: 20,
                  color: AppColors.darkLiver,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                s.orderFinishedBody,
                textAlign: TextAlign.center,
                style: AppFonts.body(
                  fontSize: 15,
                  color: AppColors.darkLiver.withValues(alpha: 0.75),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppFonts.body(
                    fontSize: 13,
                    color: const Color(0xFFE53935),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              IgnorePointer(
                ignoring: _saving,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= 5; i++)
                      IconButton(
                        onPressed: () => _rate(i),
                        iconSize: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        icon: Icon(
                          (_hovered ?? 0) >= i
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.yellow,
                        ),
                      ),
                  ],
                ),
              ),
              if (_saving) ...[
                const SizedBox(height: 8),
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
