import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_tokens.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_card.dart';
import 'package:fabula_tcg_app/core/theme/widgets/fabula_glow_container.dart';
import 'package:fabula_tcg_app/domain/entities/base_state.dart';
import 'package:fabula_tcg_app/domain/entities/territory_state.dart';

/// Displays the full territory zone (4 Surroundings + 1 Center) for a player.
///
/// Visually maps bases following tabletop ergonomics: large numerals readable
/// from 1+ meter, shield icon for protected Center, and war/alert for exposed.
class TerritoryZoneWidget extends StatelessWidget {
  const TerritoryZoneWidget({
    super.key,
    required this.territory,
    required this.onApplyDamage,
    required this.onConquerBase,
    this.isStreamMode = false,
  });

  final TerritoryState territory;

  /// Callback when the user applies damage to a base.
  final void Function(String baseId, int damage) onApplyDamage;

  /// Callback when the user confirms conquest of a base by influence.
  final void Function(String baseId) onConquerBase;

  final bool isStreamMode;

  @override
  Widget build(BuildContext context) {
    final surroundings = territory.surroundings;
    final center = territory.center;
    final isExposed = territory.isCenterExposed;
    final isLost = territory.isCenterLost;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Center status banner ---
        if (!isStreamMode) ...[
          if (isLost)
            const _StatusBanner(
              label: '💀 CENTRO PERDIDO',
              color: FabulaColors.error,
            )
          else if (isExposed)
            const _StatusBanner(
              label: '⚠️ CENTRO EXPOSTO!',
              color: FabulaColors.warning,
            ),
        ],

        // --- Surroundings row ---
        Wrap(
          alignment: WrapAlignment.center,
          spacing: FabulaTokens.space8,
          runSpacing: FabulaTokens.space8,
          children: surroundings
              .map(
                (b) => _BaseTile(
                  base: b,
                  isLocked: false,
                  onDamage: (dmg) => onApplyDamage(b.id, dmg),
                  onConquer: () => onConquerBase(b.id),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: FabulaTokens.space8),

        // --- Center tile ---
        _BaseTile(
          base: center,
          isLocked: !isExposed && !isLost,
          onDamage: (dmg) => onApplyDamage(center.id, dmg),
          onConquer: () => onConquerBase(center.id),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status banner
// ---------------------------------------------------------------------------

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FabulaGlowContainer(
      glowColor: color,
      intensity: 0.25,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: FabulaTokens.space4,
          horizontal: FabulaTokens.space8,
        ),
        margin: const EdgeInsets.only(bottom: FabulaTokens.space8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(FabulaTokens.radiusSm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: FabulaTypography.phaseLabel.copyWith(color: color),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual base tile
// ---------------------------------------------------------------------------

class _BaseTile extends StatelessWidget {
  const _BaseTile({
    required this.base,
    required this.isLocked,
    required this.onDamage,
    required this.onConquer,
  });

  final BaseState base;

  /// Whether this base is currently locked from attack/influence.
  final bool isLocked;
  final void Function(int damage) onDamage;
  final VoidCallback onConquer;

  bool get _isCenter => base.type == BaseType.center;
  bool get _isCaptured =>
      !base.isDestroyed && base.currentController != base.originalOwner;

  Color get _accentColor {
    if (base.isDestroyed) return FabulaColors.colorless;
    if (_isCaptured) return FabulaColors.purple;
    if (_isCenter) return FabulaColors.yellow;
    return FabulaColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: base.isDestroyed ? 0.4 : 1.0,
      child: FabulaCard(
        padding: const EdgeInsets.all(FabulaTokens.space8),
        borderRadius: BorderRadius.circular(FabulaTokens.radiusSm),
        borderColor: _accentColor,
        borderWidth: _isCenter ? 2.0 : 1.2,
        glowColor: base.isDestroyed ? null : _accentColor,
        child: SizedBox(
          width: _isCenter
              ? FabulaTokens.centerTileWidth
              : FabulaTokens.baseTileWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label + status icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isCenter)
                    Icon(
                      isLocked ? Icons.shield : Icons.shield_outlined,
                      size: 14,
                      color: isLocked ? FabulaColors.green : FabulaColors.error,
                    ),
                  if (_isCenter) const SizedBox(width: FabulaTokens.space4),
                  Flexible(
                    child: Text(
                      _isCenter ? 'CENTRO' : 'ARR',
                      style: FabulaTypography.caption.copyWith(
                        color: _accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isCaptured) ...[
                    const SizedBox(width: FabulaTokens.space4),
                    const Icon(Icons.flag,
                        size: 11, color: FabulaColors.purple),
                  ],
                ],
              ),

              const SizedBox(height: FabulaTokens.space2),

              // Resistance counter (large for table visibility)
              Text(
                base.isDestroyed ? '✕' : '${base.currentResistance}',
                style: (_isCenter
                        ? FabulaTypography.headlineCounter
                        : FabulaTypography.displayScore.copyWith(fontSize: 28))
                    .copyWith(color: _accentColor),
              ),

              Text(
                '/ ${base.maxResistance}',
                style: FabulaTypography.caption.copyWith(
                  color: _accentColor.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: FabulaTokens.space4),

              // Action buttons (hidden when destroyed or locked)
              if (!base.isDestroyed && !isLocked) ...[
                _ActionBar(
                  isCenter: _isCenter,
                  onDamage: onDamage,
                  onConquer: onConquer,
                ),
              ] else if (isLocked && !base.isDestroyed) ...[
                Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: FabulaColors.green.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar with damage & influence buttons + inline dialogs
// ---------------------------------------------------------------------------

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isCenter,
    required this.onDamage,
    required this.onConquer,
  });

  final bool isCenter;
  final void Function(int damage) onDamage;
  final VoidCallback onConquer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: FabulaTokens.space4,
      children: [
        _SmallActionButton(
          icon: Icons.flash_on,
          size: 16,
          padding: FabulaTokens.space4,
          color: FabulaColors.error,
          tooltip: 'Dano de Ofensiva',
          onTap: () => _showDamageDialog(context),
        ),
        _SmallActionButton(
          icon: Icons.people,
          size: 13,
          padding: 3.0,
          color: FabulaColors.purple,
          tooltip: 'Disputa de Influência',
          onTap: () => _showConquerConfirmDialog(context),
        ),
      ],
    );
  }

  Future<void> _showDamageDialog(BuildContext context) async {
    final ctrl = TextEditingController(text: '1');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aplicar Dano de Ofensiva'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: 'Pontos de dano'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: FabulaColors.error),
            onPressed: () {
              final v = int.tryParse(ctrl.text);
              if (v != null && v > 0) Navigator.pop(ctx, v);
            },
            child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result != null) onDamage(result);
  }

  Future<void> _showConquerConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disputa de Influência'),
        content: const Text('A base foi tomada por influência?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: FabulaColors.purple),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) onConquer();
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
    this.size = 16.0,
    this.padding = FabulaTokens.space4,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FabulaTokens.radiusSm),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }
}
