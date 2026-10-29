import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Large, high-visibility counter button with haptic feedback.
///
/// Designed for quick increment/decrement taps during tabletop gameplay.
class CounterButton extends StatelessWidget {
  const CounterButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size = 64.0,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  void _handlePress() {
    HapticFeedback.lightImpact();
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fg = iconColor ?? theme.colorScheme.onPrimaryContainer;

    final button = Material(
      color: bg,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _handlePress,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(
              icon,
              color: fg,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }
}

/// Compact pill containing both [-] and [+] controls.
class IncrementDecrementPill extends StatelessWidget {
  const IncrementDecrementPill({
    required this.onDecrement,
    required this.onIncrement,
    super.key,
    this.accentColor,
  });

  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            color: color,
            iconSize: 28,
            onPressed: () {
              HapticFeedback.lightImpact();
              onDecrement();
            },
          ),
          Container(
            width: 1,
            height: 24,
            color: color.withValues(alpha: 0.2),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: color,
            iconSize: 28,
            onPressed: () {
              HapticFeedback.lightImpact();
              onIncrement();
            },
          ),
        ],
      ),
    );
  }
}
