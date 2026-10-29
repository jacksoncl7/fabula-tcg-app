import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:fabula_tcg_app/core/theme/app_theme.dart';
import 'package:fabula_tcg_app/presentation/screens/home_screen.dart';
import 'package:fabula_tcg_app/presentation/state/ergonomics_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: FabulaTcgApp(),
    ),
  );
}

class FabulaTcgApp extends ConsumerWidget {
  const FabulaTcgApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ergonomics = ref.watch(ergonomicsProvider);

    // Sync screen wakelock with settings
    try {
      if (ergonomics.isWakelockEnabled) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    } catch (_) {
      // Graceful fallback for non-supported test/desktop environments
    }

    ThemeData effectiveDarkTheme = AppTheme.dark;
    ThemeData effectiveLightTheme = AppTheme.light;

    if (ergonomics.displayMode == AccessibilityDisplayMode.highContrast) {
      effectiveDarkTheme = AppTheme.highContrast;
      effectiveLightTheme = AppTheme.highContrast;
    }

    Widget appChild = const HomeScreen();

    if (ergonomics.displayMode == AccessibilityDisplayMode.grayscale) {
      appChild = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: appChild,
      );
    }

    return MaterialApp(
      title: 'Fábula TCG',
      debugShowCheckedModeBanner: false,
      theme: effectiveLightTheme,
      darkTheme: effectiveDarkTheme,
      themeMode: ergonomics.themeMode,
      home: appChild,
    );
  }
}
