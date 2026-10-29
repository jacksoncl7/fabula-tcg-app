import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/presentation/components/counter_button.dart';
import 'package:fabula_tcg_app/presentation/components/rotatable_player_zone.dart';
import 'package:fabula_tcg_app/presentation/components/territory_badge.dart';

void main() {
  group('RotatablePlayerZone', () {
    testWidgets('renders normally when isRotated is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RotatablePlayerZone(
              isRotated: false,
              child: Text('Normal View'),
            ),
          ),
        ),
      );

      expect(find.text('Normal View'), findsOneWidget);
      expect(find.byType(RotatedBox), findsNothing);
    });

    testWidgets('wraps child in RotatedBox when isRotated is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RotatablePlayerZone(
              isRotated: true,
              child: Text('Opponent View'),
            ),
          ),
        ),
      );

      expect(find.text('Opponent View'), findsOneWidget);
      final rotatedBoxFinder = find.byType(RotatedBox);
      expect(rotatedBoxFinder, findsOneWidget);
      final rotatedBox = tester.widget<RotatedBox>(rotatedBoxFinder);
      expect(rotatedBox.quarterTurns, 2);
    });
  });

  group('CounterButton', () {
    testWidgets('triggers callback on tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterButton(
              icon: Icons.add,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CounterButton));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('IncrementDecrementPill', () {
    testWidgets('triggers increment and decrement independently',
        (tester) async {
      var incrementCount = 0;
      var decrementCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncrementDecrementPill(
              onIncrement: () => incrementCount++,
              onDecrement: () => decrementCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(incrementCount, 1);
      expect(decrementCount, 0);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(decrementCount, 1);
    });
  });

  group('TerritoryBadge', () {
    testWidgets('displays title, resistance and center shield', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TerritoryBadge(
              title: 'Centro',
              resistance: 15,
              isCenter: true,
              isExposed: false,
            ),
          ),
        ),
      );

      expect(find.text('CENTRO'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('displays warning icon when exposed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TerritoryBadge(
              title: 'Centro',
              resistance: 15,
              isCenter: true,
              isExposed: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });
  });
}
