import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/property_detail_screen.dart';
import 'package:wow_cleaning/screens/schedule_status.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with WidgetsBindingObserver {
  final ScheduleApi _api = ScheduleApi();
  OrderDetailData? _data;
  bool _loading = true;
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
      final data = await _api.fetchOrderDetail(widget.orderId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _data == null) {
          _error = e.displayMessage;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _data == null) {
          _error = S.current.orderLoadFailed;
        }
      });
    }
  }

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

  String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      final dt = DateTime.parse(value).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year} · ${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return value;
    }
  }

  String _formatPrice(dynamic value) {
    if (value == null) return '';
    final number = value is num ? value.toDouble() : double.tryParse('$value');
    if (number == null) return '\$$value';
    if (number == number.roundToDouble()) return '\$${number.toInt()}';
    return '\$${number.toStringAsFixed(2)}';
  }

  String _formatHours(dynamic value) {
    if (value == null) return '';
    final number = value is num ? value.toDouble() : double.tryParse('$value');
    if (number == null) return '$value';
    if (number == number.roundToDouble()) return '${number.toInt()}';
    return number.toStringAsFixed(1);
  }

  String _timeRange(ScheduleOrder order) {
    return [
      _formatTime(order.startTime),
      _formatTime(order.endTime),
    ].where((item) => item.isNotEmpty).join(' — ');
  }

  String _scheduleTypeLabel(S s, ScheduleOrder order) {
    if (order.type == 'recurring') {
      final recurrence = switch (order.recurrence) {
        'weekly' => s.bookingWeekly,
        'biweekly' => s.bookingBiweekly,
        'monthly' => s.bookingMonthly,
        _ => null,
      };
      return recurrence == null
          ? s.bookingRecurring
          : '${s.bookingRecurring} · $recurrence';
    }
    return s.bookingOneTime;
  }

  bool get _canDelete {
    final order = _data?.order;
    if (order == null) return false;
    return !order.operatorConfirmed;
  }

  Future<void> _confirmDelete() async {
    if (_deleting || !_canDelete) return;
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
            s.deleteRequestTitle,
            style: AppFonts.headline(
              fontSize: 18,
              color: AppColors.darkLiver,
            ),
          ),
          content: Text(
            s.deleteRequestConfirm,
            style: AppFonts.body(
              fontSize: 15,
              color: AppColors.darkLiver,
            ),
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
                s.deleteRequest,
                style: AppFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await _deleteRequest();
    }
  }

  Future<void> _deleteRequest() async {
    if (_deleting) return;
    setState(() => _deleting = true);
    try {
      await _api.deleteRequest(widget.orderId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.displayMessage)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.deleteRequestFailed)),
      );
    }
  }

  String? _paymentLabel(S s, String? status) {
    if (status == null || status.isEmpty) return null;
    return switch (status) {
      'paid' => s.paymentPaid,
      'unpaid' => s.paymentUnpaid,
      'pending' || 'checkout_created' => s.paymentPending,
      'failed' => s.paymentFailed,
      _ => status.replaceAll('_', ' '),
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final order = _data?.order;
    final paymentStatus = _data?.paymentSummary['last_status']?.toString() ??
        order?.paymentStatus;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          s.cleaningDetails,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: _loading && _data == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pictonBlue),
            )
          : _error != null && _data == null
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
              : order == null
                  ? const SizedBox.shrink()
                  : RefreshIndicator(
                      color: AppColors.pictonBlue,
                      onRefresh: () => _load(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
                        children: [
                        _HeroHeader(
                          order: order,
                          statusLabel: scheduleStatusLabel(
                            s,
                            order.status,
                            order.operatorConfirmed,
                          ),
                          paymentLabel: _paymentLabel(s, paymentStatus),
                        ),
                        const SizedBox(height: 16),
                        _VisitCard(
                          label: s.orderVisit,
                          typeLabel: _scheduleTypeLabel(s, order),
                          date: _formatDate(order.date),
                          time: _timeRange(order),
                        ),
                        if (_hasProperty(order)) ...[
                          const SizedBox(height: 14),
                          _PropertyCard(order: order, s: s),
                        ],
                        if (_hasService(order)) ...[
                          const SizedBox(height: 14),
                          _ServiceCard(
                            label: s.bookingSummaryService,
                            item: order.service ??
                                OrderServiceItem(title: order.serviceName),
                          ),
                        ],
                        if (order.addons.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _AddonsCard(order: order, s: s),
                        ],
                        if ((order.notes ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _NotesCard(
                            label: s.bookingSummaryNotes,
                            notes: order.notes!.trim(),
                          ),
                        ],
                        if (order.amount != null ||
                            order.hoursDuration != null) ...[
                          const SizedBox(height: 14),
                          _EstimateCard(
                            title: s.bookingEstimateTitle,
                            price: order.amount == null
                                ? null
                                : _formatPrice(order.amount),
                            hours: order.hoursDuration == null
                                ? null
                                : s.bookingHoursValue(
                                    _formatHours(order.hoursDuration),
                                  ),
                          ),
                        ],
                        if ((_data?.statusTimeline ?? []).isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _TimelineCard(
                            title: s.statusTimelineLabel,
                            events: _data!.statusTimeline,
                            confirmed: order.operatorConfirmed,
                            formatDateTime: _formatDateTime,
                          ),
                        ],
                        if (_canDelete) ...[
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _deleting ? null : _confirmDelete,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFE53935),
                                side: const BorderSide(
                                  color: Color(0xFFE53935),
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _deleting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Color(0xFFE53935),
                                      ),
                                    )
                                  : Text(
                                      s.deleteRequest,
                                      style: AppFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFE53935),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ],
                      ),
                    ),
    );
  }

  bool _hasProperty(ScheduleOrder order) {
    return (order.propertyTitle ?? '').trim().isNotEmpty ||
        order.clientPropertyId != null;
  }

  bool _hasService(ScheduleOrder order) {
    return (order.service?.title ?? order.serviceName).trim().isNotEmpty;
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.order,
    required this.statusLabel,
    this.paymentLabel,
  });

  final ScheduleOrder order;
  final String statusLabel;
  final String? paymentLabel;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (order.service?.imageUrl ?? '').isNotEmpty
        ? order.service!.imageUrl
        : order.propertyImageUrl;
    final title = (order.service?.title ?? order.serviceName).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((imageUrl ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: AppColors.pictonBlue.withValues(alpha: 0.12),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors.pictonBlue,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (title.isNotEmpty)
          Text(
            title.toUpperCase(),
            style: AppFonts.headline(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGray,
              letterSpacing: 0.4,
            ),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _StatusChip(label: statusLabel, highlight: true),
            if ((paymentLabel ?? '').isNotEmpty)
              _StatusChip(label: paymentLabel!),
          ],
        ),
      ],
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({
    required this.label,
    required this.typeLabel,
    required this.date,
    required this.time,
  });

  final String label;
  final String typeLabel;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      date,
      time,
    ].where((item) => item.isNotEmpty).join(' · ');

    return _SoftCard(
      child: _IconRow(
        icon: Icons.calendar_month_outlined,
        label: label,
        title: typeLabel,
        subtitle: subtitle.isEmpty ? null : subtitle,
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.order, required this.s});

  final ScheduleOrder order;
  final S s;

  @override
  Widget build(BuildContext context) {
    final title = (order.propertyTitle ?? '').trim().isNotEmpty
        ? order.propertyTitle!.trim()
        : s.propertyLabel;
    final propertyId = order.clientPropertyId;

    return _SoftCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.bookingSummaryProperty.toUpperCase(),
                  style: AppFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.darkGray.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
          if (propertyId != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PropertyDetailScreen(propertyId: propertyId),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.pictonBlue,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                s.moreDetails,
                style: AppFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pictonBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.label, required this.item});

  final String label;
  final OrderServiceItem item;

  @override
  Widget build(BuildContext context) {
    final description = (item.description ?? '').trim();

    return _SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 72,
              height: 72,
              child: (item.imageUrl ?? '').isNotEmpty
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => const _SoftIcon(
                        icon: Icons.cleaning_services_outlined,
                      ),
                    )
                  : const _SoftIcon(icon: Icons.cleaning_services_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.darkGray.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: AppFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGray,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppFonts.body(
                      fontSize: 14,
                      color: AppColors.darkGray.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddonsCard extends StatelessWidget {
  const _AddonsCard({required this.order, required this.s});

  final ScheduleOrder order;
  final S s;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.bookingSummaryAddons.toUpperCase(),
            style: AppFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.darkGray.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < order.addons.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  color: AppColors.darkGray.withValues(alpha: 0.08),
                ),
              ),
            _AddonRow(item: order.addons[i]),
          ],
          if (order.windowCount != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.pictonBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${s.orderWindows}: ${order.windowCount}',
                style: AppFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pictonBlue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddonRow extends StatelessWidget {
  const _AddonRow({required this.item});

  final OrderServiceItem item;

  @override
  Widget build(BuildContext context) {
    final description = (item.description ?? '').trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 56,
            height: 56,
            child: (item.imageUrl ?? '').isNotEmpty
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => const _SoftIcon(
                      icon: Icons.add_circle_outline_rounded,
                      size: 44,
                    ),
                  )
                : const _SoftIcon(
                    icon: Icons.add_circle_outline_rounded,
                    size: 44,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGray,
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppFonts.body(
                    fontSize: 13,
                    color: AppColors.darkGray.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.label, required this.notes});

  final String label;
  final String notes;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: _IconRow(
        icon: Icons.chat_bubble_outline_rounded,
        label: label,
        title: notes,
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({
    required this.title,
    this.price,
    this.hours,
  });

  final String title;
  final String? price;
  final String? hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.darkGray.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((price ?? '').isNotEmpty)
                Expanded(
                  child: Text(
                    price!,
                    style: AppFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGray,
                    ),
                  ),
                )
              else
                const Spacer(),
              if ((hours ?? '').isNotEmpty)
                Text(
                  hours!,
                  style: AppFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGray,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.title,
    required this.events,
    required this.confirmed,
    required this.formatDateTime,
  });

  final String title;
  final List<Map<String, dynamic>> events;
  final bool confirmed;
  final String Function(String?) formatDateTime;

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.darkGray.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < events.length; i++)
            _TimelineRow(
              label: scheduleStatusLabel(
                s,
                events[i]['status']?.toString(),
                confirmed,
              ),
              time: formatDateTime(events[i]['created_at']?.toString()),
              isLast: i == events.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.time,
    required this.isLast,
  });

  final String label;
  final String time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.pictonBlue,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 28,
                  margin: const EdgeInsets.only(top: 4),
                  color: AppColors.pictonBlue.withValues(alpha: 0.2),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGray,
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: AppFonts.body(
                      fontSize: 12,
                      color: AppColors.darkGray.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({
    required this.icon,
    required this.label,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SoftIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.darkGray.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGray,
                ),
              ),
              if ((subtitle ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppFonts.body(
                    fontSize: 13,
                    color: AppColors.darkGray.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.pictonBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.pictonBlue, size: size * 0.5),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, this.highlight = false});

  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.yellow.withValues(alpha: 0.7)
            : AppColors.pictonBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: highlight ? AppColors.darkGray : AppColors.pictonBlue,
        ),
      ),
    );
  }
}
