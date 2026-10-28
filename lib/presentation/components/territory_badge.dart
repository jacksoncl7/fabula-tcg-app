import 'package:flutter/material.dart';
import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';

/// Visual badge representing base or territory type and durability.
class TerritoryBadge extends StatelessWidget {
  const TerritoryBadge({
    required this.title,
    required this.resistance,
    super.key,
    this.isCenter = false,
    this.isExposed = false,
    this.badgeColor,
    this.onTap,
  });

  final String title;
  final int resistance;
  final bool isCenter;
  final bool isExposed;
  final Color? badgeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = badgeColor ?? (isCenter ? FabulaColors.yellow : FabulaColors.blue);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExposed ? FabulaColors.red : effectiveColor,
            width: isExposed ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCenter && !isExposed)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.shield, size: 16, color: FabulaColors.yellow),
                  ),
                if (isExposed)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.warning_amber_rounded, size: 16, color: FabulaColors.red),
                  ),
                Text(
                  title.toUpperCase(),
                  style: FabulaTypography.caption.copyWith(
                    color: isExposed ? FabulaColors.red : effectiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$resistance',
              style: FabulaTypography.headlineCounter.copyWith(
                color: isExposed ? FabulaColors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Highlight chip indicating the active phase of a turn.
class PhaseChip extends StatelessWidget {
  const PhaseChip({
    required this.label,
    super.key,
    this.isActive = false,
    this.accentColor,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? FabulaColors.blue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : color.withOpacity(0.25),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: FabulaTypography.phaseLabel.copyWith(
            color: isActive ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
