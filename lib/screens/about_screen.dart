import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/config/header_layout.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  static final Uri developerUrl = Uri.parse('https://owlsolutions.net');

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _versionLabel =
      '${AppConfig.appVersion} (${AppConfig.appBuildNumber})';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      final version = info.version.trim().isEmpty
          ? AppConfig.appVersion
          : info.version;
      final build = info.buildNumber.trim().isEmpty
          ? AppConfig.appBuildNumber
          : info.buildNumber;
      setState(() => _versionLabel = '$version ($build)');
    } catch (_) {
      // Hot reload after adding the plugin, or platform stub — keep fallback.
    }
  }

  Future<void> _openDeveloperSite() async {
    final uri = AboutScreen.developerUrl;
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;

      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.openLinkFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: s.back,
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 32,
                      color: AppColors.pictonBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ClipOval(
                          child: Image.asset(
                            HeaderAssets.mascot,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'WOW NOW\nCLEANING',
                          textAlign: TextAlign.center,
                          style: AppFonts.headline(
                            fontSize: 28,
                            color: AppColors.pictonBlue,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(flex: 2),
                        Text(
                          s.versionLabel,
                          style: AppFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pictonBlue,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _versionLabel,
                          style: AppFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkLiver,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Divider(color: Color(0xFFE4E2E2), thickness: 1),
                        const SizedBox(height: 28),
                        Text(
                          s.releaseDateLabel,
                          style: AppFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pictonBlue,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.releaseDateValue,
                          style: AppFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkLiver,
                          ),
                        ),
                        const Spacer(flex: 3),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _openDeveloperSite,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    s.developedBy,
                                    style: AppFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF9A9A9A),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    'OWLSOLUTIONS',
                                    style: AppFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.pictonBlue,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FooterIcon(Icons.verified_user_outlined),
                            const SizedBox(width: 28),
                            _FooterIcon(Icons.workspace_premium_outlined),
                            const SizedBox(width: 28),
                            _FooterIcon(Icons.shield_outlined),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FooterIcon extends StatelessWidget {
  const _FooterIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 22, color: const Color(0xFF6E6E6E));
  }
}
