import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accessibility visual mode configuration.
enum AccessibilityDisplayMode {
  standard,
  highContrast,
  grayscale,
}

/// State for ergonomic and accessibility settings during a match.
@immutable
class ErgonomicsState {
  const ErgonomicsState({
    this.themeMode = ThemeMode.system,
    this.displayMode = AccessibilityDisplayMode.standard,
    this.isStreamModeActive = false,
    this.isWakelockEnabled = true,
  });

  final ThemeMode themeMode;
  final AccessibilityDisplayMode displayMode;
  final bool isStreamModeActive;
  final bool isWakelockEnabled;

  ErgonomicsState copyWith({
    ThemeMode? themeMode,
    AccessibilityDisplayMode? displayMode,
    bool? isStreamModeActive,
    bool? isWakelockEnabled,
  }) {
    return ErgonomicsState(
      themeMode: themeMode ?? this.themeMode,
      displayMode: displayMode ?? this.displayMode,
      isStreamModeActive: isStreamModeActive ?? this.isStreamModeActive,
      isWakelockEnabled: isWakelockEnabled ?? this.isWakelockEnabled,
    );
  }
}

/// Notifier to control themes, stream overlays, and table display options.
class ErgonomicsNotifier extends StateNotifier<ErgonomicsState> {
  ErgonomicsNotifier() : super(const ErgonomicsState());

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setDisplayMode(AccessibilityDisplayMode mode) {
    state = state.copyWith(displayMode: mode);
  }

  void toggleStreamMode() {
    state = state.copyWith(isStreamModeActive: !state.isStreamModeActive);
  }

  void setWakelock(bool enabled) {
    state = state.copyWith(isWakelockEnabled: enabled);
  }
}

/// Global ergonomics and accessibility provider.
final ergonomicsProvider =
    StateNotifierProvider<ErgonomicsNotifier, ErgonomicsState>((ref) {
  return ErgonomicsNotifier();
});
