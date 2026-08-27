import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/order_detail_screen.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/order_mini_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    this.onSubscribeCleaning,
    this.isActive = true,
    this.refreshTick = 0,
  });

  final VoidCallback? onSubscribeCleaning;
  final bool isActive;
  final int refreshTick;

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

  @override
  void didUpdateWidget(covariant ScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive &&
        (widget.refreshTick != oldWidget.refreshTick || !oldWidget.isActive)) {
      _load(silent: _data != null);
    }
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent || _data == null) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final data = await _api.fetchSchedule();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _data == null) {
          _error = S.current.scheduleLoadFailed;
        }
      });
    }
  }

  void _openOrder(ScheduleOrder order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(orderId: order.id),
      ),
    ).then((_) {
      if (mounted) _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;
        final data = _data;
        final requests = data?.requests ?? const <ScheduleOrder>[];
        final orders = data?.orders ?? const <ScheduleOrder>[];
        final recurring = data?.recurring ?? const <ScheduleOrder>[];

        return ColoredBox(
          color: AppColors.background,
          child: RefreshIndicator(
            color: AppColors.pictonBlue,
            onRefresh: () => _load(),
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
                  if (requests.isNotEmpty) ...[
                    _SectionCard(
                      title: s.scheduleRequests,
                      orders: requests,
                      onTap: _openOrder,
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (orders.isNotEmpty) ...[
                    _SectionCard(
                      title: s.scheduleOrders,
                      orders: orders,
                      onTap: _openOrder,
                    ),
                    const SizedBox(height: 14),
                  ],
                  _SectionCard(
                    title: s.recurringCleanings,
                    orders: recurring,
                    onTap: _openOrder,
                    footer: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onSubscribeCleaning,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pictonBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          s.subscribeCleaning,
                          style: AppFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.orders,
    required this.onTap,
    this.footer,
  });

  final String title;
  final List<ScheduleOrder> orders;
  final ValueChanged<ScheduleOrder> onTap;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowShadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: AppColors.darkGray.withValues(alpha: 0.45),
            ),
          ),
          if (orders.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderMiniCard(order: order, onTap: () => onTap(order)),
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 6),
            footer!,
          ],
        ],
      ),
    );
  }
}
