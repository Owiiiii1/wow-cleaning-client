import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/news_detail_screen.dart';
import 'package:wow_cleaning/screens/order_detail_screen.dart';
import 'package:wow_cleaning/services/home_api.dart';
import 'package:wow_cleaning/services/schedule_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/current_cleaning_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.loginData,
    this.onBookNewCleaning,
    this.isActive = true,
    this.refreshTick = 0,
  });

  final Map<String, dynamic> loginData;
  final VoidCallback? onBookNewCleaning;
  final bool isActive;
  final int refreshTick;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApi _api = HomeApi();
  HomeData? _data;
  bool _loading = true;
  String? _error;
  Timer? _trackingPoll;

  String get _fallbackName {
    final profile =
        (widget.loginData['profile'] as Map?)?.cast<String, dynamic>() ?? {};
    final client = widget.loginData['client'];
    if (profile['name'] != null && profile['name'].toString().isNotEmpty) {
      return profile['name'].toString();
    }
    if (client is Map && client['name'] != null) {
      return client['name'].toString();
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _trackingPoll?.cancel();
    super.dispose();
  }

  void _syncTrackingPoll() {
    final next = _data?.nextCleaning;
    final shouldPoll = next?.status == 'on_the_way';
    if (shouldPoll && _trackingPoll == null) {
      _trackingPoll = Timer.periodic(const Duration(seconds: 15), (_) {
        if (widget.isActive) {
          _load(silent: true);
        }
      });
    } else if (!shouldPoll) {
      _trackingPoll?.cancel();
      _trackingPoll = null;
    }
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
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
      final data = await _api.fetchHome();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
        _error = null;
      });
      _syncTrackingPoll();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _data == null) {
          _error = S.current.homeLoadFailed;
          _data ??= HomeData(userName: _fallbackName, news: const []);
        }
      });
    }
  }

  void _openOrder(int orderId) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: orderId),
          ),
        )
        .then((_) {
          if (mounted) _load();
        });
  }

  bool _isCurrentService(ScheduleOrder? order) {
    if (order == null || !order.operatorConfirmed) return false;
    return switch (order.status) {
      'accepted' || 'on_the_way' || 'started' => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;
        final data = _data;
        final name = (data?.userName.isNotEmpty == true)
            ? data!.userName
            : _fallbackName;
        final next = data?.nextCleaning;
        final specialist = data?.specialistOnTheWay;
        final news = data?.news ?? const <HomeNewsItem>[];

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
                  s.welcomeBack,
                  style: AppFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGray.withValues(alpha: 0.55),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name.isEmpty ? s.hiGuest : s.hiName(name),
                  style: AppFonts.headline(
                    fontSize: 28,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.homeTagline,
                  style: AppFonts.body(
                    fontSize: 15,
                    color: AppColors.darkGray.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: widget.onBookNewCleaning,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pictonBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.pictonBlue.withValues(
                        alpha: 0.45,
                      ),
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      s.bookNewCleaning,
                      style: AppFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  _isCurrentService(next)
                      ? s.currentService
                      : s.upcomingService,
                  style: AppFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.darkGray.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 10),
                if (_loading && data == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.pictonBlue,
                      ),
                    ),
                  )
                else if (next == null)
                  _surfaceCard(
                    child: Text(
                      s.serviceNotOrdered,
                      style: AppFonts.body(
                        fontSize: 15,
                        color: AppColors.darkGray,
                      ),
                    ),
                  )
                else
                  CurrentCleaningCard(
                    order: next,
                    specialist: specialist,
                    operatorPhone: data?.operatorPhone,
                    onOpenOrder: () => _openOrder(next.id),
                  ),
                const SizedBox(height: 22),
                Text(
                  s.news,
                  style: AppFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.darkGray.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 10),
                if (news.isEmpty)
                  Text(
                    s.newsEmpty,
                    style: AppFonts.body(
                      color: AppColors.darkGray.withValues(alpha: 0.6),
                    ),
                  )
                else
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: news.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = news[index];
                        return _NewsCard(
                          item: item,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    NewsDetailScreen(newsId: item.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
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

  Widget _surfaceCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
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

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item, required this.onTap});

  final HomeNewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? Image.network(
                      item.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: AppColors.pictonBlue.withValues(alpha: 0.1),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.darkGray,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.pictonBlue.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.newspaper_outlined,
                        color: AppColors.pictonBlue,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Text(
                item.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
