import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/request_detail_screen.dart';
import 'package:wow_cleaning/screens/request_form_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/requests_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with WidgetsBindingObserver {
  final _api = RequestsApi();
  List<ClientRequest> _items = [];
  String _scope = 'active';
  bool _loading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _timer = Timer.periodic(
      const Duration(seconds: 20),
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
    if (!silent) setState(() => _loading = true);
    try {
      final items = await _api.fetchRequests(scope: _scope);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (error) {
      if (!mounted || silent) return;
      setState(() {
        _loading = false;
        _error = error.displayMessage;
      });
    } catch (_) {
      if (!mounted || silent) return;
      setState(() {
        _loading = false;
        _error = S.current.requestsLoadFailed;
      });
    }
  }

  Future<void> _create() async {
    final created = await Navigator.of(context).push<ClientRequest>(
      MaterialPageRoute(builder: (_) => const RequestFormScreen()),
    );
    if (created != null && mounted) {
      setState(() => _scope = 'active');
      await _load();
    }
  }

  Future<void> _open(ClientRequest request) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RequestDetailScreen(requestId: request.id),
      ),
    );
    if (mounted) _load(silent: true);
  }

  String _date(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return '';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        title: Text(
          s.requests,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        backgroundColor: AppColors.pictonBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(s.newRequest),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'active', label: Text(s.requestActive)),
                ButtonSegment(
                  value: 'completed',
                  label: Text(s.requestCompleted),
                ),
                ButtonSegment(value: 'all', label: Text(s.requestAll)),
              ],
              selected: {_scope},
              onSelectionChanged: (value) {
                setState(() => _scope = value.first);
                _load();
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 92),
                children: [
                  if (_loading && _items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_error != null && _items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: AppFonts.body(color: const Color(0xFFE53935)),
                      ),
                    )
                  else if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text(
                        s.requestsEmpty,
                        textAlign: TextAlign.center,
                        style: AppFonts.body(color: AppColors.darkGray),
                      ),
                    )
                  else
                    ..._items.map(
                      (request) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => _open(request),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.pictonBlue.withValues(
                                        alpha: .12,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      request.requestType == 'cleaning_dispute'
                                          ? Icons.report_problem_outlined
                                          : Icons.forum_outlined,
                                      color: AppColors.pictonBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          s.requestTypeLabel(
                                            request.requestType,
                                          ),
                                          style: AppFonts.montserrat(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.darkGray,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          request.message,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFonts.body(
                                            color: AppColors.darkGray,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          [
                                                s.requestStatusLabel(
                                                  request.status,
                                                ),
                                                _date(request.createdAt),
                                              ]
                                              .where((part) => part.isNotEmpty)
                                              .join(' · '),
                                          style: AppFonts.body(
                                            fontSize: 12,
                                            color: AppColors.darkGray
                                                .withValues(alpha: .55),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
