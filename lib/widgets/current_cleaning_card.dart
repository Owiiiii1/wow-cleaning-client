import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/schedule_status.dart';
import 'package:wow_cleaning/services/home_api.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/live_tracking_map_sheet.dart';

class CurrentCleaningCard extends StatelessWidget {
  const CurrentCleaningCard({
    super.key,
    required this.order,
    this.specialist,
    this.operatorPhone,
    required this.onOpenOrder,
  });

  final ScheduleOrder order;
  final SpecialistOnTheWay? specialist;
  final String? operatorPhone;
  final VoidCallback onOpenOrder;

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) return '';
    final parts = value.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return value;
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      final dt = DateTime.parse(value);
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year}';
    } catch (_) {
      return value;
    }
  }

  int _stageIndex() {
    return switch (order.status) {
      'on_the_way' => 1,
      'started' => 2,
      'finished' => 2,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final date = _formatDate(order.date);
    final timePart = [
      _formatTime(order.startTime),
      _formatTime(order.endTime),
    ].where((item) => item.isNotEmpty).join(' – ');
    final addonCount = order.addonCount > 0
        ? order.addonCount
        : order.addonTitles.length;
    final stages = [s.stageAccepted, s.stageOnTheWay, s.stageCleaning];
    final current = _stageIndex();
    final showTracking = order.locationTrackingActive;
    final specialistName = specialist?.cleanerName.trim() ?? '';
    final service = order.serviceName.trim();
    final property = (order.propertyTitle ?? '').trim();
    final phone = operatorPhone?.trim() ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: order.isFrozen ? const Color(0xFFFFEBEE) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: order.isFrozen
              ? const Color(0xFFE53935)
              : AppColors.pictonBlue.withValues(alpha: 0.22),
          width: order.isFrozen ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pictonBlue.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.darkGray.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (order.isFrozen)
              Container(
                color: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Text(
                  s.orderFrozen,
                  style: AppFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            GestureDetector(
              onTap: onOpenOrder,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
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
                              Text(
                                date.isNotEmpty ? date : s.scheduleDatePending,
                                style: AppFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  color: AppColors.darkGray.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              if (timePart.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  timePart,
                                  style: AppFonts.headline(
                                    fontSize: 20,
                                    color: AppColors.pictonBlue,
                                  ),
                                ),
                              ],
                              if (service.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  service.toUpperCase(),
                                  style: AppFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              ],
                              if (property.isNotEmpty || addonCount > 0) ...[
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    if (property.isNotEmpty) property,
                                    if (addonCount > 0) '+$addonCount',
                                  ].join('  ·  '),
                                  style: AppFonts.body(
                                    fontSize: 12,
                                    color: AppColors.darkGray.withValues(
                                      alpha: 0.62,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusPill(
                              label: scheduleStatusLabel(
                                s,
                                order.status,
                                order.operatorConfirmed,
                              ),
                            ),
                            if (phone.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _CallOperatorButton(phone: phone),
                            ],
                          ],
                        ),
                      ],
                    ),
                    if (specialistName.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pictonBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.pictonBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                s.specialistRushing(specialistName),
                                style: AppFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (showTracking)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: FilledButton.icon(
                    onPressed: () {
                      showLiveTrackingMap(context, orderId: order.id);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pictonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.near_me_rounded, size: 16),
                    label: Text(
                      s.trackingButton.toUpperCase(),
                      style: AppFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FBFF),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(17),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.pictonBlue.withValues(alpha: 0.12),
                  ),
                ),
              ),
              child: _StageProgress(stages: stages, current: current),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallOperatorButton extends StatelessWidget {
  const _CallOperatorButton({required this.phone});

  final String phone;

  Future<void> _confirmAndCall(BuildContext context) async {
    final s = S.current;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            s.callOperatorConfirmTitle,
            style: AppFonts.headline(fontSize: 18, color: AppColors.darkLiver),
          ),
          content: Text(
            s.callOperatorConfirmBody.replaceAll('{phone}', phone),
            style: AppFonts.body(fontSize: 15, color: AppColors.darkLiver),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                s.cancel,
                style: AppFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkLiver,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                s.callOperatorConfirmAction,
                style: AppFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  color: AppColors.pictonBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.isEmpty) return;
    await launchUrl(Uri.parse('tel:$digits'));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    return Material(
      color: AppColors.pictonBlue.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _confirmAndCall(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phone_rounded,
                size: 13,
                color: AppColors.pictonBlue.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 5),
              Text(
                s.operatorButton,
                style: AppFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGray.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppFonts.montserrat(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: AppColors.darkGray,
        ),
      ),
    );
  }
}

class _StageProgress extends StatelessWidget {
  const _StageProgress({required this.stages, required this.current});

  final List<String> stages;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          Expanded(
            child: Column(
              children: [
                Text(
                  stages[i].toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    height: 1.2,
                    color: i == current
                        ? AppColors.pictonBlue
                        : i < current
                        ? AppColors.darkGray
                        : AppColors.darkGray.withValues(alpha: 0.38),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          color: i == 0
                              ? Colors.transparent
                              : (i <= current
                                    ? AppColors.pictonBlue
                                    : AppColors.pictonBlue.withValues(
                                        alpha: 0.18,
                                      )),
                        ),
                      ),
                      Container(
                        width: i == current ? 13 : 10,
                        height: i == current ? 13 : 10,
                        decoration: BoxDecoration(
                          color: i <= current
                              ? AppColors.pictonBlue
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: i <= current
                                ? AppColors.pictonBlue
                                : AppColors.pictonBlue.withValues(alpha: 0.28),
                            width: 2.5,
                          ),
                          boxShadow: i == current
                              ? [
                                  BoxShadow(
                                    color: AppColors.pictonBlue.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          color: i == stages.length - 1
                              ? Colors.transparent
                              : (i < current
                                    ? AppColors.pictonBlue
                                    : AppColors.pictonBlue.withValues(
                                        alpha: 0.18,
                                      )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
