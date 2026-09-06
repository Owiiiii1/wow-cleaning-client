import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/chat_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/requests_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/authorized_network_image.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key, required this.requestId});

  final int requestId;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen>
    with WidgetsBindingObserver {
  final _api = RequestsApi();
  ClientRequest? _request;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _load(silent: true),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load(silent: true);
  }

  Future<void> _load({bool silent = false}) async {
    try {
      final request = await _api.fetchRequest(widget.requestId);
      if (!mounted) return;
      setState(() {
        _request = request;
        _error = null;
      });
    } on ApiException catch (error) {
      if (!mounted || silent) return;
      setState(() => _error = error.displayMessage);
    } catch (_) {
      if (!mounted || silent) return;
      setState(() => _error = S.current.requestsLoadFailed);
    }
  }

  String _date(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return '';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year} · '
        '${two(date.hour)}:${two(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final request = _request;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        title: Text(
          s.requestDetails,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: request == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_error!, textAlign: TextAlign.center),
                    ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                s.requestTypeLabel(request.requestType),
                                style: AppFonts.headline(
                                  fontSize: 19,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ),
                            _Status(
                              label: s.requestStatusLabel(request.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          request.message,
                          style: AppFonts.body(
                            fontSize: 15,
                            color: AppColors.darkGray,
                          ),
                        ),
                        if (_date(request.createdAt).isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            _date(request.createdAt),
                            style: AppFonts.body(
                              fontSize: 12,
                              color: AppColors.darkGray.withValues(alpha: .5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (request.order != null) ...[
                    const SizedBox(height: 14),
                    _OrderSummary(
                      title: s.relatedCleaning,
                      order: request.order!,
                    ),
                  ],
                  if (request.remediationOrder != null) ...[
                    const SizedBox(height: 14),
                    _OrderSummary(
                      title: s.remediationCleaning,
                      order: request.remediationOrder!,
                    ),
                  ],
                  if (request.attachments.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Text(
                      s.photos.toUpperCase(),
                      style: AppFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: request.attachments.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 140,
                            child: AuthorizedNetworkImage(
                              url: request.attachments[index].url,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    s.operatorUpdates.toUpperCase(),
                    style: AppFonts.montserrat(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (request.publishedUpdates.isEmpty)
                    Text(
                      s.noOperatorUpdates,
                      style: AppFonts.body(color: AppColors.darkGray),
                    )
                  else
                    ...request.publishedUpdates.map(
                      (update) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                update.message,
                                style: AppFonts.body(
                                  fontSize: 15,
                                  color: AppColors.darkGray,
                                ),
                              ),
                              if (_date(update.createdAt).isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  _date(update.createdAt),
                                  style: AppFonts.body(
                                    fontSize: 12,
                                    color: AppColors.darkGray.withValues(
                                      alpha: .5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  if ((request.resolutionCode ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _Card(
                      child: Text(
                        '${s.resolution}: ${request.resolutionCode!.replaceAll('_', ' ')}',
                        style: AppFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  ],
                  if (request.canOpenChat) ...[
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChatScreen(isActive: true),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.pictonBlue,
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: Text(s.contactSupport),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: AppColors.glowShadow, blurRadius: 12)],
    ),
    child: child,
  );
}

class _Status extends StatelessWidget {
  const _Status({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: AppFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.darkGray,
      ),
    ),
  );
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.title, required this.order});
  final String title;
  final RequestOrderSummary order;

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGray.withValues(alpha: .5),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          order.title ?? '#${order.id}',
          style: AppFonts.montserrat(
            fontWeight: FontWeight.w800,
            color: AppColors.darkGray,
          ),
        ),
        if ((order.date ?? '').isNotEmpty) Text(order.date!),
        if ((order.address ?? '').isNotEmpty) Text(order.address!),
      ],
    ),
  );
}
