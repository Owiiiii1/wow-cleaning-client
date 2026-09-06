import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/branded_button.dart';

class InboxReminderActions extends StatelessWidget {
  const InboxReminderActions({
    super.key,
    required this.loading,
    required this.onConfirm,
    required this.onPostpone,
    required this.onDecline,
  });

  final bool loading;
  final VoidCallback onConfirm;
  final VoidCallback onPostpone;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BrandedButton(
          label: s.inboxConfirm,
          loading: loading,
          onPressed: onConfirm,
        ),
        const SizedBox(height: 10),
        _OutlineAction(
          label: s.inboxPostpone,
          enabled: !loading,
          onPressed: onPostpone,
        ),
        const SizedBox(height: 10),
        _OutlineAction(
          label: s.inboxDecline,
          enabled: !loading,
          onPressed: onDecline,
        ),
      ],
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkLiver,
          side: const BorderSide(color: AppColors.pictonBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: AppFonts.headline(fontSize: 16, color: AppColors.darkLiver),
        ),
      ),
    );
  }
}
