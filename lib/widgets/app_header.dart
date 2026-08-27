import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/header_layout.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/about_screen.dart';
import 'package:wow_cleaning/screens/login_screen.dart';
import 'package:wow_cleaning/screens/settings_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/session_store.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

enum _HeaderMenuAction { about, settings, logout }

/// Шапка: меню · аватар Benjamin · WOW NOW · колокольчик.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.onBellTap,
    this.hasUnread = false,
  });

  final VoidCallback? onBellTap;
  final bool hasUnread;

  Future<void> _onMenuSelected(
    BuildContext context,
    _HeaderMenuAction action,
  ) async {
    if (action == _HeaderMenuAction.about) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AboutScreen()),
      );
      return;
    }

    if (action == _HeaderMenuAction.settings) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
      return;
    }

    if (action != _HeaderMenuAction.logout) return;

    try {
      if (SessionStore.instance.isAuthenticated) {
        await ApiClient().postJson('/client/auth/logout', {});
      }
    } catch (_) {
      // Always leave the app session even if logout API fails.
    }

    SessionStore.instance.clear();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: AppColors.white,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: HeaderLayout.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HeaderLayout.horizontalPadding,
                    ),
                    child: Row(
                      children: [
                        PopupMenuButton<_HeaderMenuAction>(
                          tooltip: s.menu,
                          offset: const Offset(0, 40),
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (action) =>
                              _onMenuSelected(context, action),
                          itemBuilder: (context) => [
                            PopupMenuItem<_HeaderMenuAction>(
                              value: _HeaderMenuAction.about,
                              child: Text(
                                s.aboutApp,
                                style: AppFonts.body(
                                  color: AppColors.darkLiver,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            PopupMenuItem<_HeaderMenuAction>(
                              value: _HeaderMenuAction.settings,
                              child: Text(
                                s.settings,
                                style: AppFonts.body(
                                  color: AppColors.darkLiver,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            PopupMenuItem<_HeaderMenuAction>(
                              value: _HeaderMenuAction.logout,
                              child: Text(
                                s.logout,
                                style: AppFonts.body(
                                  color: AppColors.darkLiver,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.menu_rounded,
                              size: HeaderLayout.menuIconSize,
                              color: AppColors.darkLiver,
                            ),
                          ),
                        ),
                        const SizedBox(width: HeaderLayout.menuAvatarGap),
                        ClipOval(
                          child: Image.asset(
                            HeaderAssets.mascot,
                            width: HeaderLayout.avatarSize,
                            height: HeaderLayout.avatarSize,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(width: HeaderLayout.avatarTitleGap),
                        Expanded(
                          child: Text(
                            'WOW NOW',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.headline(
                              fontSize: HeaderLayout.titleFontSize,
                              color: AppColors.pictonBlue,
                              fontWeight: FontWeight.w700,
                              letterSpacing: HeaderLayout.titleLetterSpacing,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onBellTap,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: HeaderLayout.bellIconSize,
                                color: AppColors.darkLiver,
                              ),
                              if (hasUnread)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Text(
                                    '!',
                                    style: AppFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFE53935),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Мягкая «нависающая» тень — часть шапки на всех экранах.
            IgnorePointer(
              child: SizedBox(
                height: HeaderLayout.shadowHeight,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HeaderLayout.shadowColor,
                        HeaderLayout.shadowColor.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
