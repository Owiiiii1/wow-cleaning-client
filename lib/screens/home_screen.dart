import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/news_detail_screen.dart';
import 'package:wow_cleaning/services/home_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.loginData,
    this.onBookNewCleaning,
  });

  final Map<String, dynamic> loginData;
  final VoidCallback? onBookNewCleaning;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApi _api = HomeApi();
  HomeData? _data;
  bool _loading = true;
  String? _error;

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

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.fetchHome();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.homeLoadFailed;
        _data ??= HomeData(
          userName: _fallbackName,
          news: const [],
        );
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
            onRefresh: _load,
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
                      disabledBackgroundColor:
                          AppColors.pictonBlue.withValues(alpha: 0.45),
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
                  s.upcomingService,
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
                  _surfaceCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((next.status ?? '').isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.pictonBlue
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    next.status!.toUpperCase(),
                                    style: AppFonts.montserrat(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.pictonBlue,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                next.serviceName,
                                style: AppFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkGray,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _infoRow(
                                Icons.calendar_today_outlined,
                                _formatDate(next.date),
                              ),
                              _infoRow(
                                Icons.schedule_outlined,
                                [
                                  _formatTime(next.startTime),
                                  _formatTime(next.endTime),
                                ].where((e) => e.isNotEmpty).join(' — '),
                              ),
                              _infoRow(
                                Icons.location_on_outlined,
                                next.address ?? '—',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cleaning_services_outlined,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (specialist != null) ...[
                  const SizedBox(height: 16),
                  _surfaceCard(
                    color: AppColors.pictonBlue.withValues(alpha: 0.08),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.pictonBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.specialistRushing(specialist.cleanerName),
                                style: AppFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGray,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.specialistOnTheWayHint,
                                style: AppFonts.body(
                                  fontSize: 12,
                                  color: AppColors.darkGray
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _infoRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.darkGray.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppFonts.body(fontSize: 13, color: AppColors.darkGray),
            ),
          ),
        ],
      ),
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
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.darkGray),
                      ),
                    )
                  : Container(
                      color: AppColors.pictonBlue.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: const Icon(Icons.newspaper_outlined,
                          color: AppColors.pictonBlue),
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
