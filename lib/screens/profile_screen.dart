import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/login_screen.dart';
import 'package:wow_cleaning/screens/properties_list_screen.dart';
import 'package:wow_cleaning/screens/settings_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/session_store.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.loginData});

  final Map<String, dynamic> loginData;

  Map<String, dynamic> get _profile =>
      (loginData['profile'] as Map?)?.cast<String, dynamic>() ?? {};

  String get _name {
    final fromProfile = _profile['name']?.toString().trim() ?? '';
    if (fromProfile.isNotEmpty) return fromProfile;
    final client = loginData['client'];
    if (client is Map) {
      final n = client['name']?.toString().trim() ?? '';
      if (n.isNotEmpty) return n;
    }
    return '';
  }

  String get _email {
    final fromProfile = _profile['email']?.toString().trim() ?? '';
    if (fromProfile.isNotEmpty) return fromProfile;
    final client = loginData['client'];
    if (client is Map) {
      return client['email']?.toString().trim() ?? '';
    }
    return '';
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      if (SessionStore.instance.isAuthenticated) {
        await ApiClient().postJson('/client/auth/logout', {});
      }
    } catch (_) {
      // Always clear local session.
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
        final name = _name.isEmpty ? s.hiGuest : _name;
        final email = _email;
        final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

        return ColoredBox(
          color: AppColors.background,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pictonBlue.withValues(alpha: 0.12),
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glowShadow,
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: AppFonts.headline(
                          fontSize: 40,
                          color: AppColors.pictonBlue,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Material(
                        color: AppColors.yellow,
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: null,
                          child: const SizedBox(
                            width: 34,
                            height: 34,
                            child: Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                textAlign: TextAlign.center,
                style: AppFonts.headline(
                  fontSize: 24,
                  color: AppColors.darkGray,
                ),
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: AppFonts.body(
                    fontSize: 14,
                    color: AppColors.darkGray.withValues(alpha: 0.55),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              _SectionTitle(title: s.profileSettingsSection),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.home_work_outlined,
                label: s.savedProperties,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PropertiesListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.history_rounded,
                label: s.cleaningHistory,
                onTap: null,
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: s.supportSecuritySection),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.help_outline_rounded,
                label: s.faq,
                onTap: null,
              ),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.settings_outlined,
                label: s.settings,
                onTap: () => _openSettings(context),
              ),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.logout_rounded,
                label: s.logout,
                danger: true,
                onTap: () => _logout(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: AppColors.darkGray.withValues(alpha: 0.45),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = danger
        ? const Color(0xFFE53935)
        : AppColors.darkGray;
    final iconBg = danger
        ? const Color(0xFFE53935).withValues(alpha: 0.1)
        : AppColors.pictonBlue.withValues(alpha: 0.12);
    final iconColor = danger ? const Color(0xFFE53935) : AppColors.pictonBlue;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glowShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: AppFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.darkGray.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
