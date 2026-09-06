import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_locales.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;
        final currentCode = AppLocales.codeOf(LocaleController.instance.locale);

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text(s.settings),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: s.back,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text(
                s.changeLanguage,
                style: AppFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkLiver.withValues(alpha: 0.7),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E2E2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentCode,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.darkLiver,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: AppColors.white,
                    style: AppFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkLiver,
                    ),
                    items: [
                      for (final locale in AppLocales.supported)
                        DropdownMenuItem<String>(
                          value: AppLocales.codeOf(locale),
                          child: Text(AppLocales.nativeName(locale)),
                        ),
                    ],
                    onChanged: (code) {
                      if (code == null) return;
                      LocaleController.instance.setLocale(
                        AppLocales.fromCode(code),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
