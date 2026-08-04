import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/asset_precache.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/booking/booking_flow_screen.dart';
import 'package:wow_cleaning/screens/chat_screen.dart';
import 'package:wow_cleaning/screens/home_screen.dart';
import 'package:wow_cleaning/screens/profile_screen.dart';
import 'package:wow_cleaning/screens/schedule_screen.dart';
import 'package:wow_cleaning/services/chat_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/app_header.dart';
import 'package:wow_cleaning/widgets/bottom_nav_panel.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.loginData});

  final Map<String, dynamic> loginData;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  BottomNavTab _tab = BottomNavTab.home;
  int _chatUnread = 0;
  Timer? _unreadTimer;
  final ChatApi _chatApi = ChatApi();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AssetPrecache.warmUp(context);
      _refreshUnread();
    });
    _unreadTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_tab != BottomNavTab.chat) {
        _refreshUnread();
      }
    });
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshUnread() async {
    try {
      final count = await _chatApi.fetchUnreadCount();
      if (!mounted) return;
      setState(() => _chatUnread = count);
    } catch (_) {
      // Keep last known badge; chat tab will surface errors.
    }
  }

  void _onTabSelected(BottomNavTab tab) {
    setState(() => _tab = tab);
    if (tab == BottomNavTab.chat) {
      setState(() => _chatUnread = 0);
    } else {
      _refreshUnread();
    }
  }

  Future<void> _openBooking() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingFlowScreen(
          onFinished: (goToSchedule) {
            if (!mounted) return;
            setState(() {
              _tab = goToSchedule ? BottomNavTab.schedule : BottomNavTab.home;
            });
          },
        ),
      ),
    );
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
              const AppHeader(),
              Expanded(
                child: IndexedStack(
                  index: _tab.index,
                  children: [
                    HomeScreen(
                      loginData: widget.loginData,
                      onBookNewCleaning: _openBooking,
                    ),
                    const ScheduleScreen(),
                    ChatScreen(
                      isActive: _tab == BottomNavTab.chat,
                      onUnreadCleared: () {
                        if (_chatUnread != 0) {
                          setState(() => _chatUnread = 0);
                        }
                      },
                    ),
                    ProfileScreen(loginData: widget.loginData),
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
