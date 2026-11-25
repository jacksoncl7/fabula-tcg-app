import 'package:material_ui/material_ui.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';

/// Solid Brasofuturist card surface container.
///
/// Features solid dark elevated background with crisp borders and optional
/// subtle glow, matching the card/container patterns from fabulatcg.com.br.
class FabulaCard extends StatelessWidget {
  const FabulaCard({
    required this.child,
    super.key,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.glowColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? glowColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? FabulaColors.surfaceElevated;
    final effectiveBorderColor = borderColor ?? FabulaColors.border;
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(FabulaTokens.radiusMd);

    return Container(
      padding: padding ?? const EdgeInsets.all(FabulaTokens.space12),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: glowColor != null
            ? [
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
