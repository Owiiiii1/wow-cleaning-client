import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocaleController.instance.load();
  });

  testWidgets('Login screen renders brand UI', (WidgetTester tester) async {
    await tester.pumpWidget(const WowCleaningApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('WOW NOW'), findsWidgets);
    expect(find.text('LOG IN'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
