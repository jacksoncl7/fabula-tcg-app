import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fabula_tcg_app/presentation/state/ergonomics_provider.dart';

void main() {
  group('ErgonomicsNotifier', () {
    late ErgonomicsNotifier notifier;

    setUp(() {
      notifier = ErgonomicsNotifier();
    });

    test('initial state has default values', () {
      expect(notifier.state.themeMode, ThemeMode.system);
      expect(notifier.state.displayMode, AccessibilityDisplayMode.standard);
      expect(notifier.state.isStreamModeActive, isFalse);
      expect(notifier.state.isWakelockEnabled, isTrue);
    });

    test('setThemeMode updates themeMode', () {
      notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.state.themeMode, ThemeMode.dark);
    });

    test('setDisplayMode updates accessibility mode', () {
      notifier.setDisplayMode(AccessibilityDisplayMode.highContrast);
      expect(notifier.state.displayMode, AccessibilityDisplayMode.highContrast);
    });

    test('toggleStreamMode flips stream mode flag', () {
      notifier.toggleStreamMode();
      expect(notifier.state.isStreamModeActive, isTrue);
      notifier.toggleStreamMode();
      expect(notifier.state.isStreamModeActive, isFalse);
    });

    test('setWakelock updates wakelock flag', () {
      notifier.setWakelock(false);
      expect(notifier.state.isWakelockEnabled, isFalse);
    });
  });
}
