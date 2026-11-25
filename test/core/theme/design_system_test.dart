import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/theme/theme.dart';

void main() {
  group('FabulaColors Design Tokens', () {
    test('brand primaries match official game identity', () {
      expect(FabulaColors.white, const Color(0xFFFFFFFF));
      expect(FabulaColors.blue, const Color(0xFF0693E3));
      expect(FabulaColors.yellow, const Color(0xFFF4BB61));
      expect(FabulaColors.green, const Color(0xFF1C825B));
      expect(FabulaColors.red, const Color(0xFFCF2E2E));
      expect(FabulaColors.purple, const Color(0xFF9B51E0));
      expect(FabulaColors.colorless, const Color(0xFF636363));
    });

    test('surface tokens provide solid dark Brasofuturist palette', () {
      expect(FabulaColors.surfaceDark, const Color(0xFF111111));
      expect(FabulaColors.surfaceElevated, const Color(0xFF1A1A1A));
      expect(FabulaColors.surfaceOverlay, const Color(0xFF242424));
      expect(FabulaColors.border, const Color(0xFF333333));
    });

    test('Brasofuturist brand identity colors match official design system',
        () {
      expect(FabulaColors.brandGoldenYellow, const Color(0xFFF8BD52));
      expect(FabulaColors.brandDarkTeal, const Color(0xFF0A4038));
      expect(FabulaColors.brandCreamYellow, const Color(0xFFFCE181));
      expect(FabulaColors.brandAmberOrange, const Color(0xFFF09E38));
      expect(FabulaColors.brandForestGreen, const Color(0xFF083315));
      expect(FabulaColors.brandEmeraldGreen, const Color(0xFF126B55));
    });

    test('Brasofuturist signature accents match fabulatcg.com.br extraction',
        () {
      expect(FabulaColors.jungleGreen, const Color(0xFF00473E));
      expect(FabulaColors.navyBlue, const Color(0xFF04194E));
      expect(FabulaColors.goldenSand, const Color(0xFFFDEA8E));
      expect(FabulaColors.terracotta, const Color(0xFFD8613C));
      expect(FabulaColors.mint, const Color(0xFFE5FFD3));
      expect(FabulaColors.deepPurple, const Color(0xFF720EEC));
      expect(FabulaColors.teal, const Color(0xFF31CDCF));
    });

    test('semantic game state colors are defined', () {
      expect(FabulaColors.success, FabulaColors.green);
      expect(FabulaColors.error, FabulaColors.red);
      expect(FabulaColors.warning, FabulaColors.yellow);
    });
  });

  group('FabulaTokens Spacing & Sizing', () {
    test('spacing tokens follow expected spatial rhythm', () {
      expect(FabulaTokens.space2, 2.0);
      expect(FabulaTokens.space4, 4.0);
      expect(FabulaTokens.space8, 8.0);
      expect(FabulaTokens.space12, 12.0);
      expect(FabulaTokens.space16, 16.0);
      expect(FabulaTokens.space20, 20.0);
      expect(FabulaTokens.space24, 24.0);
      expect(FabulaTokens.space32, 32.0);
    });

    test('radii, elevation and durations are valid', () {
      expect(FabulaTokens.radiusSm, 6.0);
      expect(FabulaTokens.radiusMd, 12.0);
      expect(FabulaTokens.radiusLg, 16.0);
      expect(FabulaTokens.durationNormal, const Duration(milliseconds: 250));
    });
  });

  group('FabulaGradients', () {
    test('all presets have at least two colors', () {
      expect(FabulaGradients.nightshade.colors.length, greaterThanOrEqualTo(2));
      expect(
          FabulaGradients.purpleCrush.colors.length, greaterThanOrEqualTo(3));
      expect(FabulaGradients.golden.colors.length, greaterThanOrEqualTo(2));
      expect(FabulaGradients.midnight.colors.length, greaterThanOrEqualTo(2));
      expect(
          FabulaGradients.subduedOlive.colors.length, greaterThanOrEqualTo(2));
      expect(
          FabulaGradients.primaryAction.colors.length, greaterThanOrEqualTo(2));
      expect(
          FabulaGradients.restoration.colors.length, greaterThanOrEqualTo(2));
      expect(
          FabulaGradients.destructive.colors.length, greaterThanOrEqualTo(2));
    });
  });

  group('FabulaShadows', () {
    test('shadow presets produce valid non-empty BoxShadow lists', () {
      expect(FabulaShadows.purpleGlow, isNotEmpty);
      expect(FabulaShadows.tealGlow, isNotEmpty);
      expect(FabulaShadows.cardElevation, isNotEmpty);
      expect(FabulaShadows.dangerGlow, isNotEmpty);
      expect(FabulaShadows.warningGlow, isNotEmpty);
    });
  });

  group('FabulaTypography', () {
    test('styles specify Lexend family and table-readable font sizes', () {
      expect(FabulaTypography.fontFamily, 'Lexend');
      expect(FabulaTypography.displayScore.fontSize, 56);
      expect(FabulaTypography.headlineCounter.fontSize, 32);
      expect(FabulaTypography.headingMd.fontSize, 20);
      expect(FabulaTypography.phaseLabel.fontSize, 16);
      expect(FabulaTypography.body.fontSize, 14);
      expect(FabulaTypography.caption.fontSize, 12);
      expect(FabulaTypography.overline.fontSize, 10);
    });
  });

  group('AppTheme Configuration', () {
    test('dark theme has solid background and dark brightness', () {
      final theme = AppTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, FabulaColors.surfaceDark);
      expect(theme.colorScheme.surface, FabulaColors.surfaceDark);
      expect(theme.colorScheme.primary, FabulaColors.brandGoldenYellow);
    });

    test('light theme has solid surfaceLight background', () {
      final theme = AppTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, FabulaColors.surfaceLight);
    });

    test('highContrast theme uses pure black and yellow for table visibility',
        () {
      final theme = AppTheme.highContrast;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(theme.colorScheme.secondary, FabulaColors.yellow);
    });
  });

  group('Primitive Widgets', () {
    testWidgets('FabulaCard renders child with border and solid surface',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FabulaCard(
              glowColor: FabulaColors.teal,
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(FabulaCard), findsOneWidget);
    });

    testWidgets('FabulaGradientButton executes callback when tapped',
        (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FabulaGradientButton(
              label: 'Ação Principal',
              icon: Icons.bolt,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Ação Principal'), findsOneWidget);
      expect(find.byIcon(Icons.bolt), findsOneWidget);

      await tester.tap(find.byType(FabulaGradientButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('FabulaDivider renders properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FabulaDivider(),
          ),
        ),
      );

      expect(find.byType(FabulaDivider), findsOneWidget);
    });

    testWidgets('FabulaGlowContainer renders child with glow effect',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FabulaGlowContainer(
              glowColor: FabulaColors.yellow,
              child: Text('Glowing Element'),
            ),
          ),
        ),
      );

      expect(find.text('Glowing Element'), findsOneWidget);
      expect(find.byType(FabulaGlowContainer), findsOneWidget);
    });
  });
}
