import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/asset_precache.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/booking/booking_flow_screen.dart';
import 'package:wow_cleaning/screens/chat_screen.dart';
import 'package:wow_cleaning/screens/home_screen.dart';
import 'package:wow_cleaning/screens/inbox_list_screen.dart';
import 'package:wow_cleaning/screens/profile_screen.dart';
import 'package:wow_cleaning/screens/schedule_screen.dart';
import 'package:wow_cleaning/services/chat_api.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/app_header.dart';
import 'package:wow_cleaning/widgets/bottom_nav_panel.dart';
import 'package:wow_cleaning/widgets/inbox_message_modal.dart';
import 'package:wow_cleaning/widgets/order_finished_modal.dart';
import 'package:wow_cleaning/widgets/service_survey_modal.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.loginData});

  final Map<String, dynamic> loginData;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  BottomNavTab _tab = BottomNavTab.home;
  int _contentTick = 0;
  int _chatUnread = 0;
  int _inboxUnread = 0;
  Timer? _unreadTimer;
  final ChatApi _chatApi = ChatApi();
  final InboxApi _inboxApi = InboxApi();
  final List<InboxMessage> _unreadQueue = [];
  bool _showingInboxModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AssetPrecache.warmUp(context);
      _refreshUnread();
    });
    _unreadTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _refreshUnread();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unreadTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bumpContent();
      _refreshUnread();
    }
  }

  void _bumpContent() {
    if (!mounted) return;
    setState(() => _contentTick++);
  }

  Future<void> _refreshUnread() async {
    try {
      final results = await Future.wait([
        _chatApi.fetchUnreadCount(),
        _inboxApi.fetchUnread(),
      ]);
      if (!mounted) return;
      final inbox = results[1] as InboxUnreadSnapshot;
      setState(() {
        _chatUnread = results[0] as int;
        _inboxUnread = inbox.count;
      });
      _enqueueUnread(inbox.items);
      _showNextInboxModal();
    } catch (_) {
      // Keep last known badge; chat tab will surface errors.
    }
  }

  void _enqueueUnread(List<InboxMessage> items) {
    for (final item in items) {
      if (_unreadQueue.any((existing) => existing.id == item.id)) {
        continue;
      }
      _unreadQueue.add(item);
    }
  }

  Future<void> _showNextInboxModal() async {
    if (!mounted || _showingInboxModal || _unreadQueue.isEmpty) {
      return;
    }

    _showingInboxModal = true;
    final message = _unreadQueue.first;
    final read = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => message.isFinishedRating
          ? OrderFinishedModal(message: message)
          : InboxMessageModal(message: message),
    );
    if (!mounted) {
      return;
    }

    if (read == true && message.isFinishedRating) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => ServiceSurveyModal(messageId: message.id),
      );
      if (!mounted) {
        return;
      }
    }

    _showingInboxModal = false;
    if (read == true) {
      _unreadQueue.removeWhere((item) => item.id == message.id);
      setState(() {
        _inboxUnread = _unreadQueue.length;
      });
      _showNextInboxModal();
    }
  }

  Future<void> _openInbox() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InboxListScreen()));
    if (mounted) {
      _bumpContent();
      _refreshUnread();
    }
  }

  void _onTabSelected(BottomNavTab tab) {
    setState(() {
      _tab = tab;
      _contentTick++;
    });
    if (tab == BottomNavTab.chat) {
      setState(() => _chatUnread = 0);
    } else {
      _refreshUnread();
    }
  }

  Future<void> _openBooking({bool recurring = false}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingFlowScreen(
          startAsRecurring: recurring,
          onFinished: (goToSchedule) {
            if (!mounted) return;
            setState(() {
              _tab = goToSchedule ? BottomNavTab.schedule : BottomNavTab.home;
              _contentTick++;
            });
          },
        ),
      ),
    );
    if (mounted) _bumpContent();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              AppHeader(hasUnread: _inboxUnread > 0, onBellTap: _openInbox),
              Expanded(
                child: IndexedStack(
                  index: _tab.index,
                  children: [
                    HomeScreen(
                      loginData: widget.loginData,
                      onBookNewCleaning: _openBooking,
                      isActive: _tab == BottomNavTab.home,
                      refreshTick: _contentTick,
                    ),
                    ScheduleScreen(
                      onSubscribeCleaning: () => _openBooking(recurring: true),
                      isActive: _tab == BottomNavTab.schedule,
                      refreshTick: _contentTick,
                    ),
                    ChatScreen(
                      isActive: _tab == BottomNavTab.chat,
                      onUnreadCleared: () {
                        if (_chatUnread != 0) {
                          setState(() => _chatUnread = 0);
                        }
                      },
                    ),
                    ProfileScreen(
                      loginData: widget.loginData,
                      isActive: _tab == BottomNavTab.profile,
                      refreshTick: _contentTick,
                    ),
                  ],
                ),
              ),
              BottomNavPanel(
                currentTab: _tab,
                chatUnreadCount: _chatUnread,
                onTabSelected: _onTabSelected,
                onCenterPressed: _openBooking,
              ),
            ],
          ),
        );
      },
    );
  }
}
