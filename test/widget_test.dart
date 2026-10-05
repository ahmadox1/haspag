import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haspag/main.dart';

void main() {
  testWidgets('calculator buttons update the display', (tester) async {
    await tester.pumpWidget(const App());
    for (final key in ['7', '+', '2', '=']) {
      final button = find.byKey(ValueKey('key_$key'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const ValueKey('display'))).data, '9');
    await tester.tap(find.byKey(const ValueKey('key_C')));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const ValueKey('display'))).data, '0');
  });
}
