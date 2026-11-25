import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/presentation/screens/home_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen Central Toolbar & Turn Controls', () {
    testWidgets('renders initial turn counter TURNO 1 with J1 active',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('TURNO 1'), findsOneWidget);
      expect(find.text('J1'), findsOneWidget);
      expect(find.text('Passar p/ J2'), findsOneWidget);
    });

    testWidgets('stream mode webcam toggle button has been removed',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.videocam), findsNothing);
      expect(find.byIcon(Icons.videocam_off_outlined), findsNothing);
    });

    testWidgets(
        'individual dashboards do not have separate Próx. Turno buttons',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Próx. Turno'), findsNothing);
    });

    testWidgets('tapping unified Next Turn button alternates active player',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Passar p/ J2
      await tester.tap(find.text('Passar p/ J2'));
      await tester.pumpAndSettle();

      // Now active player is J2, button text becomes Passar p/ J1
      expect(find.text('TURNO 1'), findsOneWidget);
      expect(find.text('J2'), findsOneWidget);
      expect(find.text('Passar p/ J1'), findsOneWidget);

      // Tap Passar p/ J1 -> Completes round, increments to TURNO 2
      await tester.tap(find.text('Passar p/ J1'));
      await tester.pumpAndSettle();

      expect(find.text('TURNO 2'), findsOneWidget);
      expect(find.text('J1'), findsOneWidget);
      expect(find.text('Passar p/ J2'), findsOneWidget);
    });

    testWidgets('tapping restart button shows confirmation dialog',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Advance to Turn 2 first
      await tester.tap(find.text('Passar p/ J2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Passar p/ J1'));
      await tester.pumpAndSettle();
      expect(find.text('TURNO 2'), findsOneWidget);

      // Tap restart icon button
      final restartBtn = find.byIcon(Icons.restart_alt);
      expect(restartBtn, findsOneWidget);
      await tester.tap(restartBtn);
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Reiniciar Partida'), findsOneWidget);
      expect(
        find.text(
          'Deseja reiniciar a partida? Todos os recursos, turnos e bases voltarão ao estado inicial.',
        ),
        findsOneWidget,
      );

      // Tap Cancelar -> Nothing changes
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('TURNO 2'), findsOneWidget);

      // Tap restart again and Confirmar
      await tester.tap(restartBtn);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reiniciar'));
      await tester.pumpAndSettle();

      // Verify match state is back to TURNO 1 and J1
      expect(find.text('TURNO 1'), findsOneWidget);
      expect(find.text('J1'), findsOneWidget);
      expect(find.text('Passar p/ J2'), findsOneWidget);
    });
  });
}
