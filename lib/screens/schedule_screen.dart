import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/order_detail_screen.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleApi _api = ScheduleApi();
  ScheduleData? _data;
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
      final data = await _api.fetchSchedule();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.scheduleLoadFailed;
      });
    }
  }

  void _openOrder(ScheduleOrder order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(orderId: order.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;
        final data = _data;

        return ColoredBox(
          color: AppColors.background,
          child: RefreshIndicator(
            color: AppColors.pictonBlue,
            onRefresh: _load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Text(
                  s.mySchedule,
                  style: AppFonts.headline(
                    fontSize: 28,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.scheduleSubtitle,
                  style: AppFonts.body(
                    fontSize: 15,
                    color: AppColors.darkGray.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 20),
                if (_loading && data == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.pictonBlue,
                      ),
                    ),
                  )
                else ...[
                  _Section(
                    title: s.thisWeek,
                    orders: data?.thisWeek ?? const [],
                    emptyText: s.scheduleSectionEmpty,
                    onTap: _openOrder,
                  ),
                  const SizedBox(height: 8),
                  _Section(
                    title: s.futureCleanings,
                    orders: data?.future ?? const [],
                    emptyText: s.scheduleSectionEmpty,
                    onTap: _openOrder,
                  ),
                  const SizedBox(height: 8),
                  _Section(
                    title: s.recurringCleanings,
                    orders: data?.recurring ?? const [],
                    emptyText: s.scheduleSectionEmpty,
                    onTap: _openOrder,
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: AppFonts.body(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.orders,
    required this.emptyText,
    required this.onTap,
  });

  final String title;
  final List<ScheduleOrder> orders;
  final String emptyText;
  final ValueChanged<ScheduleOrder> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.darkGray.withValues(alpha: 0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style: AppFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.darkGray.withValues(alpha: 0.45),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.darkGray.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: AppFonts.body(
                fontSize: 13,
                color: AppColors.darkGray.withValues(alpha: 0.5),
              ),
            ),
          )
        else
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OrderCard(order: order, onTap: () => onTap(order)),
            ),
          ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final ScheduleOrder order;
  final VoidCallback onTap;

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
    final timePart = [
      _formatTime(order.startTime),
      _formatTime(order.endTime),
    ].where((e) => e.isNotEmpty).join(' — ');
    final when = [
      _formatDate(order.date),
      if (timePart.isNotEmpty) timePart,
    ].join(', ');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      shadowColor: AppColors.glowShadow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.glowShadow,
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.pictonBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors.pictonBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      order.serviceName,
                      style: AppFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  if ((order.status ?? '').isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status!.toUpperCase(),
                        style: AppFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                ],
              ),
              if (when.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: AppColors.pictonBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        when,
                        style: AppFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pictonBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Divider(height: 1, color: AppColors.darkGray.withValues(alpha: 0.08)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((order.address ?? '').isNotEmpty)
                          _metaRow(
                            Icons.location_on_outlined,
                            order.address!,
                          ),
                        if ((order.assignedTeam ?? '').isNotEmpty)
                          _metaRow(
                            Icons.person_outline,
                            order.assignedTeam!,
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.darkGray.withValues(alpha: 0.35),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.darkGray.withValues(alpha: 0.45)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppFonts.body(
                fontSize: 12,
                color: AppColors.darkGray.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
