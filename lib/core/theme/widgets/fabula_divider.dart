import 'package:flutter/material.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';

/// A gradient-fading horizontal divider in the Brasofuturist style.
class FabulaDivider extends StatelessWidget {
  const FabulaDivider({super.key, this.color, this.height = 1.0});

  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? FabulaColors.border;
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            effectiveColor.withValues(alpha: 0.0),
            effectiveColor,
            effectiveColor.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
