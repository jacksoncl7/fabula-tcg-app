import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/territory_state.dart';
import 'package:fabula_tcg_app/presentation/components/counter_button.dart';
import 'package:fabula_tcg_app/presentation/components/rotatable_player_zone.dart';
import 'package:fabula_tcg_app/presentation/components/territory_badge.dart';
import 'package:fabula_tcg_app/presentation/components/territory_zone_widget.dart';

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

  group('TerritoryZoneWidget Influence Dispute', () {
    testWidgets(
        'tapping influence button opens confirmation dialog and confirms conquest',
        (tester) async {
      String? conqueredBaseId;
      final territory = TerritoryState.initial(const PlayerId('player_1'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TerritoryZoneWidget(
                territory: territory,
                onApplyDamage: (_, __) {},
                onConquerBase: (baseId) => conqueredBaseId = baseId,
              ),
            ),
          ),
        ),
      );

      // Verify influence button is present
      final influenceButton = find.byIcon(Icons.people).first;
      expect(influenceButton, findsOneWidget);

      // Tap on influence button
      await tester.tap(influenceButton);
      await tester.pumpAndSettle();

      // Expect confirmation dialog with prompt text
      expect(find.text('Disputa de Influência'), findsOneWidget);
      expect(find.text('A base foi tomada por influência?'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);

      // Tap Confirmar
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      // Dialog should close and callback invoked
      expect(find.text('A base foi tomada por influência?'), findsNothing);
      expect(conqueredBaseId, territory.surroundings.first.id);
    });

    testWidgets('tapping Cancel in influence dialog does not trigger callback',
        (tester) async {
      String? conqueredBaseId;
      final territory = TerritoryState.initial(const PlayerId('player_1'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TerritoryZoneWidget(
                territory: territory,
                onApplyDamage: (_, __) {},
                onConquerBase: (baseId) => conqueredBaseId = baseId,
              ),
            ),
          ),
        ),
      );

      // Tap on influence button
      await tester.tap(find.byIcon(Icons.people).first);
      await tester.pumpAndSettle();

      // Tap Cancelar
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('A base foi tomada por influência?'), findsNothing);
      expect(conqueredBaseId, isNull);
    });
  });
}
