import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';
import 'package:fabula_tcg_app/presentation/components/counter_button.dart';
import 'package:fabula_tcg_app/presentation/components/rotatable_player_zone.dart';
import 'package:fabula_tcg_app/presentation/components/territory_badge.dart';
import 'package:fabula_tcg_app/presentation/state/ergonomics_provider.dart';
import 'package:fabula_tcg_app/presentation/state/providers.dart';

/// Interactive Tabletop Playmat Screen.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p1 = ref.watch(player1ResourceProvider);
    final p2 = ref.watch(player2ResourceProvider);
    final ergonomics = ref.watch(ergonomicsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Opponent zone (rotated 180° for head-to-head table play)
            Expanded(
              child: RotatablePlayerZone(
                isRotated: true,
                child: _PlayerDashboard(
                  title: 'Jogador 2 (Oponente)',
                  currentResources: p2.currentResources,
                  maxResources: p2.maxResources,
                  accentColor: FabulaColors.red,
                  onIncrement: () => ref.read(player2ResourceProvider.notifier).gainBonusResources(1),
                  onDecrement: () {
                    if (p2.currentResources > 0) {
                      ref.read(player2ResourceProvider.notifier).spendResources(1);
                    }
                  },
                  onNextTurn: () => ref.read(player2ResourceProvider.notifier).advanceToNextTurn(),
                  onRestore: () => ref.read(player2ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                ),
              ),
            ),

            // Middle Toolbar: Stream Mode, Settings, and Accessibility controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      ergonomics.isStreamModeActive ? Icons.videocam : Icons.videocam_off_outlined,
                      color: ergonomics.isStreamModeActive ? FabulaColors.green : null,
                    ),
                    tooltip: 'Modo Stream / Webcam',
                    onPressed: () => ref.read(ergonomicsProvider.notifier).toggleStreamMode(),
                  ),
                  Text(
                    'FÁBULA TCG ASSISTANT',
                    style: FabulaTypography.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<AccessibilityDisplayMode>(
                    icon: const Icon(Icons.accessibility_new),
                    tooltip: 'Acessibilidade de Mesa',
                    onSelected: (mode) => ref.read(ergonomicsProvider.notifier).setDisplayMode(mode),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: AccessibilityDisplayMode.standard,
                        child: Text('Padrão'),
                      ),
                      const PopupMenuItem(
                        value: AccessibilityDisplayMode.highContrast,
                        child: Text('Alto Contraste'),
                      ),
                      const PopupMenuItem(
                        value: AccessibilityDisplayMode.grayscale,
                        child: Text('Monocromático'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active player zone (normal orientation)
            Expanded(
              child: RotatablePlayerZone(
                isRotated: false,
                child: _PlayerDashboard(
                  title: 'Jogador 1 (Você)',
                  currentResources: p1.currentResources,
                  maxResources: p1.maxResources,
                  accentColor: FabulaColors.blue,
                  onIncrement: () => ref.read(player1ResourceProvider.notifier).gainBonusResources(1),
                  onDecrement: () {
                    if (p1.currentResources > 0) {
                      ref.read(player1ResourceProvider.notifier).spendResources(1);
                    }
                  },
                  onNextTurn: () => ref.read(player1ResourceProvider.notifier).advanceToNextTurn(),
                  onRestore: () => ref.read(player1ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerDashboard extends StatelessWidget {
  const _PlayerDashboard({
    required this.title,
    required this.currentResources,
    required this.maxResources,
    required this.accentColor,
    required this.onIncrement,
    required this.onDecrement,
    required this.onNextTurn,
    required this.onRestore,
    required this.isStreamMode,
  });

  final String title;
  final int currentResources;
  final int maxResources;
  final Color accentColor;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onNextTurn;
  final VoidCallback onRestore;
  final bool isStreamMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isStreamMode)
            Text(
              title,
              style: FabulaTypography.phaseLabel.copyWith(color: accentColor),
            ),

          // Central Resource Counter (large for table visibility)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$currentResources',
                style: FabulaTypography.displayScore.copyWith(
                  color: FabulaColors.yellow,
                ),
              ),
              Text(
                ' / $maxResources',
                style: FabulaTypography.headlineCounter.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CounterButton(
                icon: Icons.remove,
                onPressed: onDecrement,
                size: 52,
                tooltip: 'Gastar 1 Recurso',
              ),
              const SizedBox(width: 24),
              ElevatedButton.icon(
                onPressed: onRestore,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Restaurar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FabulaColors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onNextTurn,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Próx. Turno'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(width: 24),
              CounterButton(
                icon: Icons.add,
                onPressed: onIncrement,
                size: 52,
                tooltip: 'Adicionar Bônus',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
