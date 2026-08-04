import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ScheduleApi _api = ScheduleApi();
  OrderDetailData? _data;
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
      final data = await _api.fetchOrderDetail(widget.orderId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.displayMessage;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.orderLoadFailed;
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

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final order = _data?.order;

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
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    Text(
                      order?.serviceName ?? '',
                      style: AppFonts.headline(
                        fontSize: 24,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if ((order?.status ?? '').isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.yellow.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order!.status!.toUpperCase(),
                            style: AppFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    _card(
                      children: [
                        _row(s.address, order?.address),
                        _row(
                          s.dateLabel,
                          _formatDate(order?.date),
                        ),
                        _row(
                          s.timeLabel,
                          [
                            _formatTime(order?.startTime),
                            _formatTime(order?.endTime),
                          ].where((e) => e.isNotEmpty).join(' — '),
                        ),
                        _row(s.paymentStatusLabel, order?.paymentStatus),
                        _row(s.typeLabel, order?.type),
                        _row(
                          s.specialistLabel,
                          order?.cleanerName ?? order?.assignedTeam,
                        ),
                        if (order?.hoursDuration != null)
                          _row(
                            s.durationLabel,
                            '${order!.hoursDuration}',
                          ),
                      ],
                    ),
                    if ((order?.cleanerInstructions ?? '').isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _card(
                        children: [
                          Text(
                            s.instructionsLabel,
                            style: AppFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            order!.cleanerInstructions!,
                            style: AppFonts.body(color: AppColors.darkGray),
                          ),
                        ],
                      ),
                    ],
                    if ((_data?.statusTimeline ?? []).isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _card(
                        children: [
                          Text(
                            s.statusTimelineLabel,
                            style: AppFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._data!.statusTimeline.map((event) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: const BoxDecoration(
                                      color: AppColors.pictonBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event['status']?.toString() ?? '',
                                          style: AppFonts.montserrat(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkGray,
                                          ),
                                        ),
                                        if ((event['comment']?.toString() ?? '')
                                            .isNotEmpty)
                                          Text(
                                            event['comment'].toString(),
                                            style: AppFonts.body(
                                              fontSize: 12,
                                              color: AppColors.darkGray
                                                  .withValues(alpha: 0.65),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ],
                ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: children,
      ),
    );
  }

  Widget _row(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppFonts.body(
                fontSize: 13,
                color: AppColors.darkGray.withValues(alpha: 0.55),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
