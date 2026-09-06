import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/bottom_nav_buttons.dart';
import 'package:wow_cleaning/config/bottom_nav_layout.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/bottom_nav_panel_background.dart';

enum BottomNavTab { home, schedule, chat, profile }

/// Нижняя панель: фон [panel0] + 4 слота + центральная кнопка.
/// Размеры/позиции кнопок — [BottomNavButtons].
class BottomNavPanel extends StatelessWidget {
  const BottomNavPanel({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.onCenterPressed,
    this.chatUnreadCount = 0,
  });

  final BottomNavTab currentTab;
  final ValueChanged<BottomNavTab> onTabSelected;
  final VoidCallback? onCenterPressed;
  final int chatUnreadCount;

  @override
  Widget build(BuildContext context) {
    final scale = BottomNavButtons.heightScale;
    final panelH = BottomNavButtons.globalHeight;
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final liftGap = panelH * BottomNavLayout.panelBottomLiftFactor;
    // +globalOffsetY поднимает всю конструкцию, низ добивается кромкой панели.
    final bottomFill = math.max(
      0.0,
      safeBottom + liftGap + BottomNavButtons.globalOffsetY,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: BottomNavLayout.panelHorizontalInset,
        right: BottomNavLayout.panelHorizontalInset,
        bottom: BottomNavLayout.panelBottomGap,
      ),
      child: SizedBox(
        height: panelH + bottomFill,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelW = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: BottomNavPanelBackground(
                    contentHeight: panelH,
                    bottomInset: bottomFill,
                  ),
                ),
                _slot(
                  panelW: panelW,
                  centerX: BottomNavButtons.homeCenterX,
                  offsetY: BottomNavButtons.homeOffsetY * scale + bottomFill,
                  width: BottomNavButtons.homeWidth * scale,
                  height: BottomNavButtons.homeHeight * scale,
                  child: _HomeNavItem(
                    selected: currentTab == BottomNavTab.home,
                    onTap: () => onTabSelected(BottomNavTab.home),
                  ),
                ),
                _slot(
                  panelW: panelW,
                  centerX: BottomNavButtons.scheduleCenterX,
                  offsetY:
                      BottomNavButtons.scheduleOffsetY * scale + bottomFill,
                  width: BottomNavButtons.scheduleWidth * scale,
                  height: BottomNavButtons.scheduleHeight * scale,
                  child: _ScheduleNavItem(
                    selected: currentTab == BottomNavTab.schedule,
                    onTap: () => onTabSelected(BottomNavTab.schedule),
                  ),
                ),
                _slot(
                  panelW: panelW,
                  centerX: BottomNavButtons.chatCenterX,
                  offsetY: BottomNavButtons.chatOffsetY * scale + bottomFill,
                  width: BottomNavButtons.chatWidth * scale,
                  height: BottomNavButtons.chatHeight * scale,
                  child: _ChatNavItem(
                    selected: currentTab == BottomNavTab.chat,
                    unreadCount: chatUnreadCount,
                    onTap: () => onTabSelected(BottomNavTab.chat),
                  ),
                ),
                _slot(
                  panelW: panelW,
                  centerX: BottomNavButtons.profileCenterX,
                  offsetY: BottomNavButtons.profileOffsetY * scale + bottomFill,
                  width: BottomNavButtons.profileWidth * scale,
                  height: BottomNavButtons.profileHeight * scale,
                  child: _ProfileNavItem(
                    selected: currentTab == BottomNavTab.profile,
                    onTap: () => onTabSelected(BottomNavTab.profile),
                  ),
                ),
                _centerButton(
                  panelW: panelW,
                  bottomFill: bottomFill,
                  scale: scale,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _slot({
    required double panelW,
    required double centerX,
    required double offsetY,
    required double width,
    required double height,
    required Widget child,
  }) {
    final left = panelW * centerX - width / 2;

    return Positioned(
      left: left,
      bottom: offsetY,
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (BottomNavLayout.showSlotGuides)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.7),
                ),
                color: Colors.redAccent.withValues(alpha: 0.08),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget _centerButton({
    required double panelW,
    required double bottomFill,
    required double scale,
  }) {
    final size = BottomNavButtons.centerSize * scale;
    final left = panelW / 2 - size / 2 + BottomNavButtons.centerOffsetX * scale;

    return Positioned(
      left: left,
      bottom: BottomNavButtons.centerOffsetY * scale + bottomFill,
      width: size,
      height: size,
      child: _CenterNavButton(onPressed: onCenterPressed),
    );
  }
}

/// Центральная кнопка: клик → нажатый ассет → отпускание.
class _CenterNavButton extends StatefulWidget {
  const _CenterNavButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<_CenterNavButton> createState() => _CenterNavButtonState();
}

class _CenterNavButtonState extends State<_CenterNavButton> {
  bool _pressed = false;

  Future<void> _handleTap() async {
    if (_pressed) return;

    setState(() => _pressed = true);
    widget.onPressed?.call();

    await Future<void>.delayed(BottomNavLayout.centerButtonPressDuration);
    if (!mounted) return;
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (BottomNavLayout.showSlotGuides)
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange.withValues(alpha: 0.8)),
              ),
            ),
          // Оба ассета всегда в дереве — без мигания при первой смене.
          ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  BottomNavAssets.centerButton,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
                Opacity(
                  opacity: _pressed ? 1 : 0,
                  child: Image.asset(
                    BottomNavAssets.centerButtonPressed,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Image.asset(
        selected ? BottomNavAssets.homeActive : BottomNavAssets.homeInactive,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _ScheduleNavItem extends StatelessWidget {
  const _ScheduleNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Image.asset(
        selected
            ? BottomNavAssets.scheduleActive
            : BottomNavAssets.scheduleInactive,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _ChatNavItem extends StatelessWidget {
  const _ChatNavItem({
    required this.selected,
    required this.onTap,
    this.unreadCount = 0,
  });

  final bool selected;
  final VoidCallback onTap;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              selected
                  ? BottomNavAssets.chatActive
                  : BottomNavAssets.chatInactive,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '!',
                  style: TextStyle(
                    color: AppColors.darkLiver,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  const _ProfileNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Image.asset(
        selected
            ? BottomNavAssets.profileActive
            : BottomNavAssets.profileInactive,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
