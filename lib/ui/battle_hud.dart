import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/battle/battle_game.dart';
import '../game/enums.dart';

const _panelBg = Color(0xE6111418);
const _panelBorder = Color(0xFF3A4250);
const _cyan = Color(0xFF00AEEF);
const _green = Color(0xFF39FF14);
const _red = Color(0xFFFF5252);
const _amber = Color(0xFFFFD60A);

class BattleHud extends StatelessWidget {
  const BattleHud({super.key, required this.game});

  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.hudTick,
      builder: (context, value, child) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _Top(game: game),
            ),
            if (game.toastMessage != null)
              Positioned(
                top: 70,
                left: 40,
                right: 40,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC0A0E14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _cyan),
                    ),
                    child: Text(
                      game.toastMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (game.outcome != BattleOutcome.ongoing)
              Positioned.fill(
                child: _OutcomeBanner(outcome: game.outcome),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _Bottom(game: game),
            ),
          ],
        );
      },
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    final gate = game.gate;
    final hp = gate?.hpRatio ?? 0;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 10,
        right: 10,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        color: _panelBg,
        border: Border(bottom: BorderSide(color: _panelBorder)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fort, color: _red, size: 18),
          const SizedBox(width: 6),
          const Text(
            'ASEDIO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Puerta ${(hp * 100).round()}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hp,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF1A1F28),
                    color: _red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.timer, color: Colors.white70, size: 16),
          const SizedBox(width: 4),
          Text(
            game.formatTimeLeft(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: game.requestRetreat,
            style: TextButton.styleFrom(
              foregroundColor: _amber,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('RETIRADA', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _OutcomeBanner extends StatelessWidget {
  const _OutcomeBanner({required this.outcome});
  final BattleOutcome outcome;

  @override
  Widget build(BuildContext context) {
    late String title;
    late Color color;
    switch (outcome) {
      case BattleOutcome.victory:
        title = '¡VICTORIA!';
        color = _green;
      case BattleOutcome.defeat:
        title = 'DERROTA';
        color = _red;
      case BattleOutcome.retreat:
        title = 'RETIRADA';
        color = _amber;
      case BattleOutcome.ongoing:
        title = '';
        color = Colors.white;
    }
    return ColoredBox(
      color: const Color(0x88000000),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: _panelBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({required this.game});
  final BattleGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: _panelBg,
        border: Border(top: BorderSide(color: _panelBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 72,
            child: Row(
              children: [
                for (final g in game.groups) ...[
                  Expanded(child: _GroupButton(game: game, kind: g.kind)),
                  if (g != game.groups.last) const SizedBox(width: 4),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Cmd(
                label: 'Cargar',
                icon: Icons.flash_on,
                color: _red,
                onTap: () => game.issueCommand(BattleCommand.cargar),
              ),
              _Cmd(
                label: 'Mantener',
                icon: Icons.shield,
                color: _amber,
                onTap: () => game.issueCommand(BattleCommand.mantener),
              ),
              _Cmd(
                label: 'Retirar',
                icon: Icons.undo,
                color: _cyan,
                onTap: () => game.issueCommand(BattleCommand.retirar),
              ),
              _Cmd(
                label: 'Fuego conc.',
                icon: Icons.my_location,
                color: _green,
                onTap: () =>
                    game.issueCommand(BattleCommand.fuegoConcentrado),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Arrastra un grupo a la zona · toca el mapa para mover',
            style: TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _GroupButton extends StatelessWidget {
  const _GroupButton({required this.game, required this.kind});
  final BattleGame game;
  final BattleGroupKind kind;

  @override
  Widget build(BuildContext context) {
    final g = game.groupOf(kind)!;
    final selected = game.selectedGroup == kind;
    final locked = !g.unlocked;
    final empty = g.unlocked && g.aliveCount <= 0;
    final color = locked
        ? Colors.white24
        : (selected ? _cyan : (empty ? Colors.white38 : _green));

    Widget body = Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: selected ? 2.5 : 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            locked
                ? Icons.lock
                : (kind == BattleGroupKind.naves
                    ? Icons.rocket_launch
                    : Icons.groups),
            color: color,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            kind.shortEs,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            locked
                ? '🔒'
                : (empty ? '0' : '${g.aliveCount}'),
            style: TextStyle(color: color.withValues(alpha: 0.85), fontSize: 11),
          ),
        ],
      ),
    );

    if (locked || empty) {
      return GestureDetector(
        onTap: () => game.selectGroup(kind),
        child: body,
      );
    }

    return LongPressDraggable<BattleGroupKind>(
      data: kind,
      delay: const Duration(milliseconds: 120),
      onDragStarted: () => game.beginDragGroup(kind),
      onDraggableCanceled: (velocity, offset) => game.cancelDrag(),
      onDragEnd: (_) => game.cancelDrag(),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Opacity(opacity: 0.85, child: body),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: body),
      child: DragTarget<BattleGroupKind>(
        onAcceptWithDetails: (details) {
          // Drop on another button ignored; map drop via Listener below.
        },
        builder: (context, cand, rej) {
          return GestureDetector(
            onTap: () => game.selectGroup(kind),
            child: body,
          );
        },
      ),
    );
  }
}

/// Full-screen drag target layered behind bottom panel via parent Stack?
/// We wrap the game area using a listener in [BattleHud] — simpler: use
/// overlay [Listener] for global pointer-up while dragging.
class BattleDragLayer extends StatelessWidget {
  const BattleDragLayer({super.key, required this.game, required this.child});
  final BattleGame game;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<BattleGroupKind>(
      onAcceptWithDetails: (details) {
        final o = details.offset;
        game.dropGroupAt(details.data, Vector2(o.dx + 36, o.dy + 36));
      },
      builder: (context, candidate, rejected) => child,
    );
  }
}

class _Cmd extends StatelessWidget {
  const _Cmd({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F28),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.75)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

