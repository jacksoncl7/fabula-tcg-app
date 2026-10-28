import 'package:flutter/material.dart';

/// Typography configuration tailored for table play visibility.
///
/// Ensures clear readability from 1+ meter distance across game mats.
abstract final class FabulaTypography {
  /// Huge numeric displays (e.g. current resources, life counters).
  static const TextStyle displayScore = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Secondary large counter (e.g. max resources / base resistance).
  static const TextStyle headlineCounter = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Phase badge / status labels.
  static const TextStyle phaseLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  /// Table-readable action button labels.
  static const TextStyle actionButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  /// Micro stat captions.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );
}
