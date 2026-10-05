import 'package:flutter_test/flutter_test.dart';
import 'package:haspag/main.dart';

void main() {
  testWidgets('app renders', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
