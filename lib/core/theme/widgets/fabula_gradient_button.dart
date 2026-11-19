import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_gradients.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';

/// A gradient-filled button for primary actions in the Brasofuturist style.
class FabulaGradientButton extends StatelessWidget {
  const FabulaGradientButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.gradient,
    this.padding,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient ?? FabulaGradients.primaryAction,
            borderRadius: BorderRadius.circular(FabulaTokens.radiusMd),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: FabulaTokens.space16,
                vertical: FabulaTokens.space12,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: FabulaColors.white),
                const SizedBox(width: FabulaTokens.space8),
              ],
              Text(
                label,
                style: FabulaTypography.actionButton.copyWith(
                  color: FabulaColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
