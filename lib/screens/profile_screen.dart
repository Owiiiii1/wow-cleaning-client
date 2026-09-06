import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/cleaning_history_screen.dart';
import 'package:wow_cleaning/screens/login_screen.dart';
import 'package:wow_cleaning/screens/properties_list_screen.dart';
import 'package:wow_cleaning/screens/requests_screen.dart';
import 'package:wow_cleaning/screens/settings_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/payment_method_api.dart';
import 'package:wow_cleaning/services/session_store.dart';
import 'package:wow_cleaning/services/stripe_payment_coordinator.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/branded_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.loginData,
    this.isActive = true,
    this.refreshTick = 0,
  });

  final Map<String, dynamic> loginData;
  final bool isActive;
  final int refreshTick;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PaymentMethodApi _paymentMethodApi = PaymentMethodApi();
  final StripePaymentCoordinator _stripe = StripePaymentCoordinator();
  bool _loadingCard = true;
  PaymentMethodStatus? _card;

  Map<String, dynamic> get loginData => widget.loginData;

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

  @override
  void initState() {
    super.initState();
    _loadCard();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final becameActive = widget.isActive && !oldWidget.isActive;
    final tickWhileActive =
        widget.isActive && widget.refreshTick != oldWidget.refreshTick;
    if (becameActive || tickWhileActive) {
      _loadCard();
    }
  }

  Future<void> _loadCard() async {
    try {
      final status = await _paymentMethodApi.fetch();
      if (!mounted) return;
      setState(() {
        _card = status;
        _loadingCard = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCard = false);
    }
  }

  Future<void> _requestUnlink() async {
    final s = S.current;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.paymentCardUnlinkTitle),
        content: Text(s.paymentCardUnlinkConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.paymentCardUnlink),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _loadingCard = true);
    try {
      final status = await _paymentMethodApi.unlink();
      if (!mounted) return;
      setState(() {
        _card = status;
        _loadingCard = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.paymentCardUnlinked)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCard = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.paymentCardUnlinkFailed)));
    }
  }

  Future<void> _addCard() async {
    setState(() => _loadingCard = true);
    try {
      final status = await _stripe.setupCard();
      if (!mounted) return;
      setState(() {
        _card = status;
        _loadingCard = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCard = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.cardSetupCancelled)));
    }
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
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
        final initial = name.isNotEmpty
            ? name.characters.first.toUpperCase()
            : '?';

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
                        border: Border.all(color: Colors.white, width: 4),
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
              const SizedBox(height: 24),
              _SectionTitle(title: s.paymentCardSection),
              const SizedBox(height: 10),
              _PaymentCardTile(
                loading: _loadingCard,
                card: _card?.hasCard == true ? _card?.paymentMethod : null,
                noneLabel: s.paymentCardNone,
                unlinkLabel: s.paymentCardUnlink,
                expiryLabel: (_card?.paymentMethod?.expiryLabel != null)
                    ? s.paymentCardExpiry(_card!.paymentMethod!.expiryLabel!)
                    : null,
                onUnlink: _requestUnlink,
                addLabel: s.paymentCardAdd,
                onAdd: _addCard,
              ),
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CleaningHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: s.supportSecuritySection),
              const SizedBox(height: 10),
              _ProfileTile(
                icon: Icons.support_agent_rounded,
                label: s.requests,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RequestsScreen()),
                  );
                },
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
    final color = danger ? const Color(0xFFE53935) : AppColors.darkGray;
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

class _PaymentCardTile extends StatelessWidget {
  const _PaymentCardTile({
    required this.loading,
    required this.card,
    required this.noneLabel,
    required this.unlinkLabel,
    required this.addLabel,
    this.expiryLabel,
    this.onUnlink,
    this.onAdd,
  });

  final bool loading;
  final SavedPaymentMethod? card;
  final String noneLabel;
  final String unlinkLabel;
  final String addLabel;
  final String? expiryLabel;
  final VoidCallback? onUnlink;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.pictonBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.credit_card_rounded,
                    color: AppColors.pictonBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card?.displayLabel ?? noneLabel,
                              style: AppFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGray,
                              ),
                            ),
                            if (card != null && expiryLabel != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                expiryLabel!,
                                style: AppFonts.body(
                                  fontSize: 12,
                                  color: AppColors.darkGray.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),
            if (!loading && card != null && onUnlink != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: onUnlink,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    unlinkLabel,
                    style: AppFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            ],
            if (!loading && card == null && onAdd != null) ...[
              const SizedBox(height: 12),
              BrandedButton(label: addLabel, onPressed: onAdd),
            ],
          ],
        ),
      ),
    );
  }
}
