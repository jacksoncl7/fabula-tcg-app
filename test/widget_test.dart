// Smoke test: verifies the app boots without errors.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/main.dart';

void main() {
  testWidgets('App boots without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FabulaTcgApp()),
    );
    // Allow async frames to settle
    await tester.pumpAndSettle();
    // App renders without throwing
    expect(tester.takeException(), isNull);
  });
}
