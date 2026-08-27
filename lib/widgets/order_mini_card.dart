import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/schedule_status.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class OrderMiniCard extends StatelessWidget {
  const OrderMiniCard({
    super.key,
    required this.order,
    required this.onTap,
    this.color,
    this.elevated = false,
  });

  final ScheduleOrder order;
  final VoidCallback onTap;
  final Color? color;
  final bool elevated;

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

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final timePart = [
      _formatTime(order.startTime),
      _formatTime(order.endTime),
    ].where((item) => item.isNotEmpty).join('–');
    final when = [
      _formatDate(order.date),
      if (timePart.isNotEmpty) timePart,
    ].join(' · ');
    final addonCount =
        order.addonCount > 0 ? order.addonCount : order.addonTitles.length;

    return Material(
      color: color ?? AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: elevated
              ? BoxDecoration(
                  color: color ?? Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowShadow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      when.isNotEmpty ? when : s.scheduleDatePending,
                      style: AppFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  OrderStatusChip(
                    label: scheduleStatusLabel(
                      s,
                      order.status,
                      order.operatorConfirmed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if ((order.propertyTitle ?? '').isNotEmpty)
                    OrderInfoChip(label: order.propertyTitle!),
                  if (order.serviceName.isNotEmpty)
                    OrderInfoChip(label: order.serviceName, emphasized: true),
                  if (addonCount > 0) OrderInfoChip(label: '+$addonCount'),
                ],
              ),
              if (order.rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        i <= order.rating!
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 16,
                        color: AppColors.yellow,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.darkGray,
        ),
      ),
    );
  }
}

class OrderInfoChip extends StatelessWidget {
  const OrderInfoChip({super.key, required this.label, this.emphasized = false});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.pictonBlue.withValues(alpha: 0.12)
            : AppColors.darkGray.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: emphasized
              ? AppColors.pictonBlue
              : AppColors.darkGray.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
