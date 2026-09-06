import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/home_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final HomeApi _api = HomeApi();
  NewsDetail? _detail;
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
      final detail = await _api.fetchNewsDetail(widget.newsId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
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
        _error = S.current.newsLoadFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final detail = _detail;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          s.news,
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                if (detail?.imageUrl != null && detail!.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        detail.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          color: AppColors.pictonBlue.withValues(alpha: 0.12),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_outlined,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final title = (detail?.title ?? '').trim().isNotEmpty
                        ? detail!.title!.trim()
                        : (detail?.shortDescription ?? '').trim();
                    if (title.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        title,
                        style: AppFonts.headline(
                          fontSize: 22,
                          color: AppColors.darkGray,
                        ),
                      ),
                    );
                  },
                ),
                Html(
                  data: detail?.bodyHtml?.isNotEmpty == true
                      ? detail!.bodyHtml!
                      : '<p></p>',
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(15),
                      color: AppColors.darkGray,
                      fontFamily: AppFonts.family,
                    ),
                  },
                ),
              ],
            ),
    );
  }
}
