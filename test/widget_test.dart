import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haspag/main.dart';
import 'package:haspag/suitcase_shell.dart';

void main() {
  Future<void> press(WidgetTester tester, String key) async {
    final button = find.byKey(ValueKey('key_$key'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  testWidgets('suitcase calculator buttons update the display', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(SuitcaseShell), findsOneWidget);
    for (final key in ['7', '+', '2', '=']) {
      await press(tester, key);
    }
    expect(tester.widget<Text>(find.byKey(const ValueKey('display'))).data, '9');
    await press(tester, 'C');
    expect(tester.widget<Text>(find.byKey(const ValueKey('display'))).data, '0');
    expect(tester.takeException(), isNull);
  });

  testWidgets('keys remain reachable on a small Arabic dark screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    // MaterialApp resolves the device language from the preferred locales list.
    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearLocalesTestValue();
      tester.platformDispatcher.clearPlatformBrightnessTestValue();
    });
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Home));
    expect(Localizations.localeOf(context).languageCode, 'ar');
    expect(Directionality.of(context), TextDirection.rtl);
    expect(Theme.of(context).brightness, Brightness.dark);

    for (final key in ['8', '÷', '0', '=']) {
      await press(tester, key);
    }
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('display'))).data,
      'تعذّر الحساب',
    );
    await press(tester, 'C');
    expect(tester.widget<Text>(find.byKey(const ValueKey('display'))).data, '0');
    expect(tester.takeException(), isNull);
  });
}
