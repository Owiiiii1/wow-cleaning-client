import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/order_detail_screen.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/order_mini_card.dart';

class CleaningHistoryScreen extends StatefulWidget {
  const CleaningHistoryScreen({super.key});

  @override
  State<CleaningHistoryScreen> createState() => _CleaningHistoryScreenState();
}

class _CleaningHistoryScreenState extends State<CleaningHistoryScreen> {
  final ScheduleApi _api = ScheduleApi();
  List<ScheduleOrder> _items = [];
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
      final items = await _api.fetchHistory();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.cleaningHistoryLoadFailed;
      });
    }
  }

  Future<void> _open(ScheduleOrder order) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: order.id)),
    );
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          s.cleaningHistory,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.pictonBlue,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            if (_loading && _items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null && _items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _error!,
                  style: AppFonts.body(color: const Color(0xFFE53935)),
                ),
              )
            else if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(s.cleaningHistoryEmpty, style: AppFonts.body()),
              )
            else
              ..._items.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrderMiniCard(
                    order: order,
                    elevated: true,
                    onTap: () => _open(order),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
