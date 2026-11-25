import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_gradients.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_card.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_gradient_button.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
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

/// Confirmation dialog for restarting the match.
Future<void> _showResetConfirmDialog(
    BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reiniciar Partida'),
      content: const Text(
        'Deseja reiniciar a partida? Todos os recursos, turnos e bases voltarão ao estado inicial.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: FabulaColors.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Reiniciar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    ref.read(matchProvider.notifier).resetMatch(
          p1Resource: ref.read(player1ResourceProvider.notifier),
          p2Resource: ref.read(player2ResourceProvider.notifier),
          p1Territory: ref.read(player1TerritoryProvider.notifier),
          p2Territory: ref.read(player2TerritoryProvider.notifier),
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
    final match = ref.watch(matchProvider);
    final ergonomics = ref.watch(ergonomicsProvider);

    final isP1Active = match.activePlayer == const PlayerId('player_1');

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
                  title: 'Jogador 2',
                  isActive: !isP1Active,
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
                  onRestore: () =>
                      ref.read(player2ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                  territory: t2,
                  onApplyDamage: (baseId, dmg) => _safeDo(
                    context,
                    () =>
                        ref.read(player2TerritoryProvider.notifier).applyDamage(
                              baseId,
                              dmg,
                            ),
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

            // Middle Toolbar: Reset button, Explicit Turn Counter, Unified Next Turn, Accessibility
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FabulaTokens.space12,
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
                  // Restart game button
                  IconButton(
                    icon: const Icon(Icons.restart_alt),
                    tooltip: 'Reiniciar Partida',
                    color: FabulaColors.textSecondary,
                    onPressed: () => _showResetConfirmDialog(context, ref),
                  ),

                  // Explicit Turn Counter + Active Player indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FabulaTokens.space12,
                      vertical: FabulaTokens.space4,
                    ),
                    decoration: BoxDecoration(
                      color: FabulaColors.surfaceElevated,
                      borderRadius:
                          BorderRadius.circular(FabulaTokens.radiusSm),
                      border: Border.all(
                        color:
                            (isP1Active ? FabulaColors.blue : FabulaColors.red)
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TURNO ${match.turnNumber}',
                          style: FabulaTypography.caption.copyWith(
                            fontWeight: FontWeight.w900,
                            color: FabulaColors.textPrimary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: FabulaTokens.space8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isP1Active
                                ? FabulaColors.blue
                                : FabulaColors.red,
                          ),
                        ),
                        const SizedBox(width: FabulaTokens.space4),
                        Text(
                          isP1Active ? 'J1' : 'J2',
                          style: FabulaTypography.caption.copyWith(
                            color: isP1Active
                                ? FabulaColors.blue
                                : FabulaColors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Unified Next Turn button
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(matchProvider.notifier).advanceTurn(
                            p1Resource:
                                ref.read(player1ResourceProvider.notifier),
                            p2Resource:
                                ref.read(player2ResourceProvider.notifier),
                          );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(
                      isP1Active ? 'Passar p/ J2' : 'Passar p/ J1',
                      style: FabulaTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isP1Active ? FabulaColors.blue : FabulaColors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: FabulaTokens.space12,
                        vertical: FabulaTokens.space8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(FabulaTokens.radiusSm),
                      ),
                    ),
                  ),

                  // Tabletop Accessibility settings
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
                  title: 'Jogador 1',
                  isActive: isP1Active,
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
                  onRestore: () =>
                      ref.read(player1ResourceProvider.notifier).restore(),
                  isStreamMode: ergonomics.isStreamModeActive,
                  territory: t1,
                  onApplyDamage: (baseId, dmg) => _safeDo(
                    context,
                    () =>
                        ref.read(player1TerritoryProvider.notifier).applyDamage(
                              baseId,
                              dmg,
                            ),
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
    required this.isActive,
    required this.currentResources,
    required this.maxResources,
    required this.accentColor,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRestore,
    required this.isStreamMode,
    required this.territory,
    required this.onApplyDamage,
    required this.onConquerBase,
  });

  final String title;
  final bool isActive;
  final int currentResources;
  final int maxResources;
  final Color accentColor;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: FabulaTypography.phaseLabel.copyWith(
                        color: accentColor,
                        fontWeight:
                            isActive ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: FabulaTokens.space8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FabulaTokens.space8,
                          vertical: FabulaTokens.space2,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(FabulaTokens.radiusSm),
                          border: Border.all(color: accentColor, width: 1),
                        ),
                        child: Text(
                          'SUA VEZ',
                          style: FabulaTypography.overline.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Central Resource Counter (large for table visibility)
            FabulaCard(
              padding: const EdgeInsets.symmetric(
                horizontal: FabulaTokens.space24,
                vertical: FabulaTokens.space4,
              ),
              borderColor: accentColor.withValues(alpha: isActive ? 0.6 : 0.2),
              glowColor: isActive ? accentColor : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$currentResources',
                    style: FabulaTypography.displayScore.copyWith(
                      color: FabulaColors.brandGoldenYellow,
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

            // Resource controls (increment, decrement, restore)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterButton(
                  icon: Icons.remove,
                  onPressed: onDecrement,
                  size: FabulaTokens.counterButtonSize,
                  tooltip: 'Gastar 1 Recurso',
                ),
                const SizedBox(width: FabulaTokens.space24),
                FabulaGradientButton(
                  onPressed: onRestore,
                  icon: Icons.refresh,
                  label: 'Restaurar',
                  gradient: FabulaGradients.restoration,
                ),
                const SizedBox(width: FabulaTokens.space24),
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
