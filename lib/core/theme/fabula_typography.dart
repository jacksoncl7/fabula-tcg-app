import 'package:flutter/material.dart';

/// Typography configuration tailored for tabletop play visibility and
/// emulating the visual hierarchy of fabulatcg.com.br.
///
/// Uses Lexend (website primary) with fallback to Inter and platform sans-serif.
abstract final class FabulaTypography {
  static const String fontFamily = 'Lexend';
  static const List<String> fontFallbacks = ['Inter', 'Roboto', 'sans-serif'];

  /// Huge numeric displays (e.g. current resources, life counters).
  /// Ensures clear readability from 1+ meter distance across game mats.
  static const TextStyle displayScore = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Secondary large counter (e.g. max resources / base resistance).
  static const TextStyle headlineCounter = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Medium headings for section titles and card headers.
  static const TextStyle headingMd = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.3,
  );

  /// Phase badge / status labels.
  static const TextStyle phaseLabel = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.4,
  );

  /// Body text for descriptions and instructions.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Table-readable action button labels.
  static const TextStyle actionButton = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Micro stat captions.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Overline / micro-label uppercase tags.
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.5,
  );
}
