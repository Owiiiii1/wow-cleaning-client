import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, this.storeUrl});

  final String? storeUrl;

  Future<void> _openStore(BuildContext context) async {
    final raw = storeUrl?.trim() ?? '';
    if (raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.openLinkFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final canOpen = (storeUrl ?? '').trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          child: Column(
            children: [
              const Spacer(),
              ClipOval(
                child: Image.asset(
                  'asset/benjamin.png',
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'WOW NOW',
                style: AppFonts.headline(
                  fontSize: 22,
                  color: AppColors.pictonBlue,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                s.updateAppTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppFonts.headline(
                  fontSize: 22,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                s.updateAppBody,
                textAlign: TextAlign.center,
                style: AppFonts.body(
                  fontSize: 15,
                  color: AppColors.darkGray.withValues(alpha: 0.72),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: canOpen ? () => _openStore(context) : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.pictonBlue,
                    disabledBackgroundColor: AppColors.pictonBlue.withValues(
                      alpha: 0.4,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    s.updateAppButton,
                    style: AppFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
