import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_gradients.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_card.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_gradient_button.dart';
import 'package:fabula_tcg_app/domain/entities/territory_state.dart';
import 'package:fabula_tcg_app/presentation/components/counter_button.dart';
import 'package:fabula_tcg_app/presentation/components/rotatable_player_zone.dart';
import 'package:fabula_tcg_app/presentation/components/territory_zone_widget.dart';
import 'package:fabula_tcg_app/presentation/state/ergonomics_provider.dart';
import 'package:fabula_tcg_app/presentation/state/providers.dart';

/// Shows a [SnackBar] on [GameRuleException]s.
void _safeDo(BuildContext context, void Function() action) {
  try {
    action();
  } on GameRuleException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
        backgroundColor: FabulaColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Interactive Tabletop Playmat Screen with Brasofuturist styling.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p1 = ref.watch(player1ResourceProvider);
    final p2 = ref.watch(player2ResourceProvider);
    final t1 = ref.watch(player1TerritoryProvider);
    final t2 = ref.watch(player2TerritoryProvider);
    final ergonomics = ref.watch(ergonomicsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  onIncrement: () => ref
                      .read(player2ResourceProvider.notifier)
                      .gainBonusResources(1),
                  onDecrement: () {
                    if (p2.currentResources > 0) {
                      ref
                          .read(player2ResourceProvider.notifier)
                          .spendResources(1);
                    }
                  },
                  onNextTurn: () => ref
                      .read(player2ResourceProvider.notifier)
                      .advanceToNextTurn(),
                  onRestore: () =>
                      ref.read(player2ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                  territory: t2,
                  onApplyDamage: (baseId, dmg) => _safeDo(
                    context,
                    () => ref
                        .read(player2TerritoryProvider.notifier)
                        .applyDamage(baseId, dmg),
                  ),
                  onConquerBase: (baseId) => _safeDo(
                    context,
                    () =>
                        ref.read(player2TerritoryProvider.notifier).conquerBase(
                              baseId: baseId,
                              newController: p1.playerId,
                            ),
                  ),
                ),
              ),
            ),

            // Middle Toolbar: Stream Mode, Settings, and Accessibility controls
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FabulaTokens.space16,
                vertical: FabulaTokens.space4,
              ),
              decoration: const BoxDecoration(
                color: FabulaColors.surfaceOverlay,
                border: Border.symmetric(
                  horizontal: BorderSide(color: FabulaColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      ergonomics.isStreamModeActive
                          ? Icons.videocam
                          : Icons.videocam_off_outlined,
                      color: ergonomics.isStreamModeActive
                          ? FabulaColors.green
                          : null,
                    ),
                    tooltip: 'Modo Stream / Webcam',
                    onPressed: () => ref
                        .read(ergonomicsProvider.notifier)
                        .toggleStreamMode(),
                  ),
                  Text(
                    'FÁBULA TCG ASSISTANT',
                    style: FabulaTypography.overline.copyWith(
                      color: FabulaColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  PopupMenuButton<AccessibilityDisplayMode>(
                    icon: const Icon(Icons.accessibility_new),
                    tooltip: 'Acessibilidade de Mesa',
                    onSelected: (mode) => ref
                        .read(ergonomicsProvider.notifier)
                        .setDisplayMode(mode),
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
                  onIncrement: () => ref
                      .read(player1ResourceProvider.notifier)
                      .gainBonusResources(1),
                  onDecrement: () {
                    if (p1.currentResources > 0) {
                      ref
                          .read(player1ResourceProvider.notifier)
                          .spendResources(1);
                    }
                  },
                  onNextTurn: () => ref
                      .read(player1ResourceProvider.notifier)
                      .advanceToNextTurn(),
                  onRestore: () =>
                      ref.read(player1ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                  territory: t1,
                  onApplyDamage: (baseId, dmg) => _safeDo(
                    context,
                    () => ref
                        .read(player1TerritoryProvider.notifier)
                        .applyDamage(baseId, dmg),
                  ),
                  onConquerBase: (baseId) => _safeDo(
                    context,
                    () =>
                        ref.read(player1TerritoryProvider.notifier).conquerBase(
                              baseId: baseId,
                              newController: p2.playerId,
                            ),
                  ),
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
    required this.territory,
    required this.onApplyDamage,
    required this.onConquerBase,
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
  final TerritoryState territory;
  final void Function(String baseId, int damage) onApplyDamage;
  final void Function(String baseId) onConquerBase;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FabulaTokens.space16,
          vertical: FabulaTokens.space8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!isStreamMode)
              Padding(
                padding: const EdgeInsets.only(bottom: FabulaTokens.space4),
                child: Text(
                  title,
                  style:
                      FabulaTypography.phaseLabel.copyWith(color: accentColor),
                ),
              ),

            // Central Resource Counter (large for table visibility)
            FabulaCard(
              padding: const EdgeInsets.symmetric(
                horizontal: FabulaTokens.space24,
                vertical: FabulaTokens.space4,
              ),
              borderColor: accentColor.withValues(alpha: 0.3),
              glowColor: accentColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                      color: FabulaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: FabulaTokens.space8),

            // Resource controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterButton(
                  icon: Icons.remove,
                  onPressed: onDecrement,
                  size: FabulaTokens.counterButtonSize,
                  tooltip: 'Gastar 1 Recurso',
                ),
                const SizedBox(width: FabulaTokens.space16),
                FabulaGradientButton(
                  onPressed: onRestore,
                  icon: Icons.refresh,
                  label: 'Restaurar',
                  gradient: FabulaGradients.restoration,
                ),
                const SizedBox(width: FabulaTokens.space12),
                OutlinedButton.icon(
                  onPressed: onNextTurn,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Próx. Turno'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FabulaTokens.space14,
                      vertical: FabulaTokens.space12,
                    ),
                  ),
                ),
                const SizedBox(width: FabulaTokens.space16),
                CounterButton(
                  icon: Icons.add,
                  onPressed: onIncrement,
                  size: FabulaTokens.counterButtonSize,
                  tooltip: 'Adicionar Bônus',
                ),
              ],
            ),

            const SizedBox(height: FabulaTokens.space8),

            // Territory zone
            if (!isStreamMode)
              TerritoryZoneWidget(
                territory: territory,
                onApplyDamage: onApplyDamage,
                onConquerBase: onConquerBase,
                isStreamMode: isStreamMode,
              ),
          ],
        ),
      ),
    );
  }
}
