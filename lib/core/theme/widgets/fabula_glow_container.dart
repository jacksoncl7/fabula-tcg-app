import 'package:flutter/material.dart';

import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';

/// Wraps a child widget with an atmospheric color glow.
///
/// Used around territory zones, exposed-center warnings, and
/// other high-attention game elements.
class FabulaGlowContainer extends StatelessWidget {
  const FabulaGlowContainer({
    required this.child,
    required this.glowColor,
    super.key,
    this.intensity = 0.2,
    this.blurRadius = 16.0,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final Color glowColor;
  final double intensity;
  final double blurRadius;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? BorderRadius.circular(FabulaTokens.radiusMd),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: intensity),
            blurRadius: blurRadius,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
