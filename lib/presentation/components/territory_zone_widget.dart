import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';
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
    required this.onResolveInfluence,
    this.isStreamMode = false,
  });

  final TerritoryState territory;

  /// Callback when the user applies damage to a base.
  final void Function(String baseId, int damage) onApplyDamage;

  /// Callback when the user resolves an influence contest on a base.
  final void Function(
    String baseId,
    int attackerInfluence,
    int blockerInfluence,
  ) onResolveInfluence;

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
              color: FabulaColors.red,
            )
          else if (isExposed)
            const _StatusBanner(
              label: '⚠️ CENTRO EXPOSTO!',
              color: FabulaColors.yellow,
            ),
        ],

        // --- Surroundings row ---
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: surroundings
              .map(
                (b) => _BaseTile(
                  base: b,
                  isLocked: false,
                  onDamage: (dmg) => onApplyDamage(b.id, dmg),
                  onInfluence: (atk, blk) => onResolveInfluence(b.id, atk, blk),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 8),

        // --- Center tile ---
        _BaseTile(
          base: center,
          isLocked: !isExposed && !isLost,
          onDamage: (dmg) => onApplyDamage(center.id, dmg),
          onInfluence: (atk, blk) => onResolveInfluence(center.id, atk, blk),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: FabulaTypography.phaseLabel.copyWith(color: color),
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
    required this.onInfluence,
  });

  final BaseState base;

  /// Whether this base is currently locked from attack/influence.
  final bool isLocked;
  final void Function(int damage) onDamage;
  final void Function(int atk, int blk) onInfluence;

  bool get _isCenter => base.type == BaseType.center;
  bool get _isCaptured =>
      !base.isDestroyed && base.currentController != base.originalOwner;

  Color get _accentColor {
    if (base.isDestroyed) return Colors.grey;
    if (_isCaptured) return FabulaColors.purple;
    if (_isCenter) return FabulaColors.yellow;
    return FabulaColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: base.isDestroyed ? 0.4 : 1.0,
      child: Container(
        width: _isCenter ? 160 : 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: _accentColor,
            width: _isCenter ? 2.5 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _accentColor.withValues(alpha: 0.08),
        ),
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
                    color: isLocked ? FabulaColors.green : FabulaColors.red,
                  ),
                if (_isCenter) const SizedBox(width: 4),
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
                  const SizedBox(width: 4),
                  const Icon(Icons.flag, size: 11, color: FabulaColors.purple),
                ],
              ],
            ),

            const SizedBox(height: 2),

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

            const SizedBox(height: 4),

            // Action buttons (hidden when destroyed or locked)
            if (!base.isDestroyed && !isLocked) ...[
              _ActionBar(
                isCenter: _isCenter,
                onDamage: onDamage,
                onInfluence: onInfluence,
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
    required this.onInfluence,
  });

  final bool isCenter;
  final void Function(int damage) onDamage;
  final void Function(int atk, int blk) onInfluence;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      children: [
        _SmallActionButton(
          icon: Icons.flash_on,
          color: FabulaColors.red,
          tooltip: 'Dano de Ofensiva',
          onTap: () => _showDamageDialog(context),
        ),
        _SmallActionButton(
          icon: Icons.people,
          color: FabulaColors.purple,
          tooltip: 'Disputa de Influência',
          onTap: () => _showInfluenceDialog(context),
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
            style: ElevatedButton.styleFrom(backgroundColor: FabulaColors.red),
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

  Future<void> _showInfluenceDialog(BuildContext context) async {
    final atkCtrl = TextEditingController(text: '0');
    final blkCtrl = TextEditingController(text: '0');
    final result = await showDialog<(int, int)>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disputa de Influência'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: atkCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  const InputDecoration(labelText: 'Influência Atacante'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: blkCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  const InputDecoration(labelText: 'Influência Bloqueadora'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: FabulaColors.purple),
            onPressed: () {
              final atk = int.tryParse(atkCtrl.text) ?? 0;
              final blk = int.tryParse(blkCtrl.text) ?? 0;
              Navigator.pop(ctx, (atk, blk));
            },
            child:
                const Text('Resolver', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result != null) onInfluence(result.$1, result.$2);
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
