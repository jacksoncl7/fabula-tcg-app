import 'package:material_ui/material_ui.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';

/// Design tokens and theme configuration for Fábula TCG Companion App.
///
/// Implements the Brasofuturist visual language extracted from fabulatcg.com.br
/// with solid background surfaces and tabletop ergonomics.
abstract final class AppTheme {
  // Re-export color aliases for backward compatibility
  static const Color fabulaWhite = FabulaColors.white;
  static const Color fabulaBlue = FabulaColors.blue;
  static const Color fabulaYellow = FabulaColors.yellow;
  static const Color fabulaGreen = FabulaColors.green;
  static const Color fabulaRed = FabulaColors.red;
  static const Color fabulaPurple = FabulaColors.purple;
  static const Color fabulaColorless = FabulaColors.colorless;

  /// Brasofuturist Dark Theme (Primary Theme)
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: FabulaColors.surfaceDark,
        colorScheme: const ColorScheme.dark(
          primary: FabulaColors.purple,
          onPrimary: FabulaColors.white,
          primaryContainer: FabulaColors.surfaceOverlay,
          onPrimaryContainer: FabulaColors.purple,
          secondary: FabulaColors.teal,
          onSecondary: FabulaColors.white,
          secondaryContainer: FabulaColors.surfaceElevated,
          onSecondaryContainer: FabulaColors.teal,
          tertiary: FabulaColors.yellow,
          onTertiary: FabulaColors.surfaceDark,
          surface: FabulaColors.surfaceDark,
          onSurface: FabulaColors.textPrimary,
          surfaceContainerHighest: FabulaColors.surfaceOverlay,
          outline: FabulaColors.border,
          error: FabulaColors.error,
          onError: FabulaColors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: FabulaTypography.displayScore,
          headlineMedium: FabulaTypography.headlineCounter,
          headlineSmall: FabulaTypography.headingMd,
          titleMedium: FabulaTypography.phaseLabel,
          bodyMedium: FabulaTypography.body,
          labelLarge: FabulaTypography.actionButton,
          bodySmall: FabulaTypography.caption,
          labelSmall: FabulaTypography.overline,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: FabulaColors.surfaceDark,
          foregroundColor: FabulaColors.textPrimary,
        ),
        cardTheme: CardThemeData(
          color: FabulaColors.surfaceElevated,
          elevation: FabulaTokens.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
            side: const BorderSide(color: FabulaColors.border, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: FabulaColors.purple,
            foregroundColor: FabulaColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: FabulaTokens.space16,
              vertical: FabulaTokens.space12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
            ),
            textStyle: FabulaTypography.actionButton,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: FabulaColors.teal,
            side: const BorderSide(color: FabulaColors.teal, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: FabulaTokens.space16,
              vertical: FabulaTokens.space12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
            ),
            textStyle: FabulaTypography.actionButton,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: FabulaColors.textSecondary,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: FabulaColors.border,
          thickness: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: FabulaColors.surfaceOverlay,
          contentTextStyle: FabulaTypography.body.copyWith(
            color: FabulaColors.textPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: FabulaColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FabulaTokens.radiusLg),
            side: const BorderSide(color: FabulaColors.border),
          ),
          titleTextStyle: FabulaTypography.headingMd.copyWith(
            color: FabulaColors.textPrimary,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: FabulaColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
            side: const BorderSide(color: FabulaColors.border),
          ),
        ),
      );

  /// Light Theme (secondary variant)
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: FabulaColors.surfaceLight,
        colorScheme: const ColorScheme.light(
          primary: FabulaColors.jungleGreen,
          onPrimary: FabulaColors.white,
          secondary: FabulaColors.teal,
          surface: FabulaColors.surfaceLight,
          onSurface: FabulaColors.surfaceDark,
          outline: Color(0xFFCBD5E0),
          error: FabulaColors.error,
        ),
        textTheme: const TextTheme(
          displayLarge: FabulaTypography.displayScore,
          headlineMedium: FabulaTypography.headlineCounter,
          headlineSmall: FabulaTypography.headingMd,
          titleMedium: FabulaTypography.phaseLabel,
          bodyMedium: FabulaTypography.body,
          labelLarge: FabulaTypography.actionButton,
          bodySmall: FabulaTypography.caption,
          labelSmall: FabulaTypography.overline,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: FabulaColors.surfaceLight,
        ),
      );

  /// High-Contrast Table Theme (tournaments & distant viewing)
  static ThemeData get highContrast => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: FabulaColors.yellow,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: FabulaColors.yellow,
          ),
        ),
      );
}
