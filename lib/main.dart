import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/l10n/app_locales.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/login_screen.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/app_version_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.load();
  runApp(const WowCleaningApp());
}

class WowCleaningApp extends StatelessWidget {
  const WowCleaningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: LocaleController.instance.locale,
          supportedLocales: AppLocales.supported,
          localeListResolutionCallback: (_, supportedLocales) =>
              LocaleController.instance.locale,
          localeResolutionCallback: (_, supportedLocale) =>
              LocaleController.instance.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AppVersionGate(child: LoginScreen()),
        );
      },
    );
  }
}
