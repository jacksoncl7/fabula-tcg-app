import 'package:flutter/material.dart';

/// Rotates its child by 180 degrees if [isRotated] is true.
///
/// Designed for 2-player tabletop matches on a single device,
/// allowing the opponent's view to be mirrored seamlessly.
class RotatablePlayerZone extends StatelessWidget {
  const RotatablePlayerZone({
    required this.child,
    super.key,
    this.isRotated = false,
  });

  final Widget child;
  final bool isRotated;

  @override
  Widget build(BuildContext context) {
    if (!isRotated) {
      return child;
    }

    return RotatedBox(
      quarterTurns: 2,
      child: child,
    );
  }
}
