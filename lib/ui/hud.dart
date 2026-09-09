import 'package:flutter/material.dart';

import '../game/balance.dart';
import '../game/enums.dart';
import '../game/rts_game.dart';
import '../game/components/unit.dart';

const _mineralBlue = Color(0xFF00AEEF);
const _energyGreen = Color(0xFF39FF14);
const _panelBg = Color(0xE6111418);
const _panelBorder = Color(0xFF3A4250);

class RtsHud extends StatelessWidget {
  const RtsHud({super.key, required this.game});

  final RtsGame game;

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
              child: _TopBar(game: game),
            ),
            Positioned(
              left: 8,
              top: 64,
              child: _ControlGroups(game: game),
            ),
            Positioned(
              right: 8,
              top: 64,
              child: _Minimap(game: game),
            ),
            Positioned(
              right: 8,
              bottom: 210,
              child: _ZoomButtons(game: game),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomPanel(game: game),
            ),
            if (game.toastMessage != null)
              Positioned(
                top: 56,
                left: 48,
                right: 48,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC0A0E14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _mineralBlue),
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
          ],
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    final e = game.economy;
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
          _ResChip(
            icon: Icons.diamond,
            color: _mineralBlue,
            value: '${e.minerals}',
            rate: '+${e.mineralRatePerMin}/min',
          ),
          const SizedBox(width: 12),
          _ResChip(
            icon: Icons.wb_sunny,
            color: _energyGreen,
            value: '${e.energy}',
            rate: '+${e.energyRatePerMin}/min',
          ),
          const SizedBox(width: 12),
          _ResChip(
            icon: Icons.groups,
            color: _energyGreen,
            value: '${e.supplyUsed}/${e.supplyMax}',
            rate: e.supplyUsed >= e.supplyMax ? 'LLENO' : 'OK',
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                game.formatTime(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResChip extends StatelessWidget {
  const _ResChip({
    required this.icon,
    required this.color,
    required this.value,
    required this.rate,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              rate,
              style: TextStyle(color: color.withValues(alpha: 0.75), fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

class _ControlGroups extends StatelessWidget {
  const _ControlGroups({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (i) {
        final n = i + 1;
        final count = game.controlGroups[n]?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: GestureDetector(
            onTap: () => game.recallControlGroup(n),
            onLongPress: () => game.assignControlGroup(n),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _panelBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: count > 0 ? _mineralBlue : _panelBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    count > 0 ? '$count' : '—',
                    style: TextStyle(
                      color: count > 0 ? _energyGreen : Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Minimap extends StatelessWidget {
  const _Minimap({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: _panelBg,
        shape: BoxShape.circle,
        border: Border.all(color: _mineralBlue, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _MinimapPainter(game),
      ),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  _MinimapPainter(this.game);
  final RtsGame game;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF2A1A10);
    canvas.drawRect(Offset.zero & size, bg);
    double sx(double x) => x / Balance.mapWidth * size.width;
    double sy(double y) => y / Balance.mapHeight * size.height;

    for (final r in game.resources) {
      canvas.drawCircle(
        Offset(sx(r.position.x), sy(r.position.y)),
        2.5,
        Paint()..color = _mineralBlue,
      );
    }
    for (final b in game.buildings) {
      final color = b.kind == BuildingKind.solarPanel
          ? _energyGreen
          : (b.kind == BuildingKind.laboratory ||
                  b.kind == BuildingKind.starport)
              ? const Color(0xFFB388FF)
              : _mineralBlue;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(sx(b.position.x), sy(b.position.y)),
          width: 5,
          height: 5,
        ),
        Paint()..color = color,
      );
    }
    for (final u in game.units) {
      canvas.drawCircle(
        Offset(sx(u.position.x), sy(u.position.y)),
        1.8,
        Paint()..color = const Color(0xFF7DD3FC),
      );
    }
    final cam = game.camera.viewfinder.position;
    final zoom = game.camera.viewfinder.zoom;
    final vw = (game.size.x / zoom) / Balance.mapWidth * size.width;
    final vh = (game.size.y / zoom) / Balance.mapHeight * size.height;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(sx(cam.x), sy(cam.y)),
        width: vw.clamp(8, size.width),
        height: vh.clamp(8, size.height),
      ),
      Paint()
        ..color = Colors.white70
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ZoomButtons extends StatelessWidget {
  const _ZoomButtons({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _smallBtn(Icons.add, () => game.zoomBy(1.15)),
        const SizedBox(height: 6),
        _smallBtn(Icons.remove, () => game.zoomBy(1 / 1.15)),
      ],
    );
  }

  Widget _smallBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _panelBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _panelBorder),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.game});
  final RtsGame game;

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
          _ProductionQueueRow(game: game),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SelectionRow(game: game)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _CommandCard(game: game)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductionQueueRow extends StatelessWidget {
  const _ProductionQueueRow({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    final items = game.production.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'COLA DE PRODUCCIÓN  ${items.length}/${Balance.maxQueueSlots}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            if (game.research.shipConstructionUnlocked)
              const Text(
                'TECH NAVES ✓',
                style: TextStyle(
                  color: _energyGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (game.research.isBusy && game.research.items.isNotEmpty)
              Text(
                'INV ${game.research.items.first.kind.shortEs} ${game.research.items.first.remaining.ceil()}s',
                style: const TextStyle(
                  color: Color(0xFFB388FF),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: Balance.maxQueueSlots,
            separatorBuilder: (context, index) => const SizedBox(width: 4),
            itemBuilder: (context, i) {
              final has = i < items.length;
              return GestureDetector(
                onTap: has ? () => game.cancelQueueAt(i) : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F28),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: has ? _mineralBlue : _panelBorder,
                    ),
                  ),
                  child: has
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              items[i].kind.shortEs,
                              style: const TextStyle(
                                color: _mineralBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '${items[i].remaining.ceil()}s',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    final units = game.selectedUnits;
    final buildings = game.selectedBuildings;

    if (units.isEmpty && buildings.isEmpty) {
      return const SizedBox(
        height: 72,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Sin selección',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ),
      );
    }

    if (buildings.isNotEmpty) {
      final b = buildings.first;
      final pct = (b.buildProgress * 100).clamp(0, 100).floor();
      return SizedBox(
        height: 72,
        child: Row(
          children: [
            _portrait(
              label: b.kind.shortEs,
              hp: '${b.hp}/${b.maxHp}',
              progress: b.isComplete ? b.hp / b.maxHp : b.buildProgress,
              subtitle: b.isComplete
                  ? b.kind.labelEs
                  : 'Obra $pct%',
            ),
            if (!b.isComplete) ...[
              const SizedBox(width: 8),
              _actionChip(
                'Continuar\nconstruir',
                () => game.resumeConstruction(b),
              ),
            ],
            if (b.canTrainWorkers) ...[
              const SizedBox(width: 8),
              _actionChip(
                'Obrero\n${Balance.workerMineralCost}💎',
                () => game.trainWorker(),
              ),
            ],
            if (b.canTrainMilitary) ...[
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _actionChip(
                        'Finn\n${Balance.infantryFrogMineralCost}💎',
                        () => game.trainUnit(UnitKind.infantryFrog),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Barbara\n${Balance.infantryBeeMineralCost}💎/${Balance.infantryBeeEnergyCost}☀',
                        () => game.trainUnit(UnitKind.infantryBee),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Rover\n${Balance.roverMineralCost}💎/${Balance.roverEnergyCost}☀',
                        () => game.trainUnit(UnitKind.rover),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Mech\n${Balance.mechMineralCost}💎/${Balance.mechEnergyCost}☀',
                        () => game.trainUnit(UnitKind.mech),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (b.canResearch) ...[
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          'INVESTIGAR',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (game.research.shipConstructionUnlocked)
                        _actionChip('Naves\nLISTO ✓', () {
                          game.showToast('«Construcción de naves» ya investigado');
                        })
                      else if (game.research.isBusy &&
                          game.research.items.isNotEmpty &&
                          game.research.items.first.kind ==
                              TechKind.shipConstruction)
                        _actionChip(
                          'Naves\n${game.research.items.first.remaining.ceil()}s',
                          () => game.cancelResearch(),
                        )
                      else
                        _actionChip(
                          'Naves\n${Balance.techShipConstructionMineralCost}💎/${Balance.techShipConstructionEnergyCost}☀',
                          () => game.researchTech(TechKind.shipConstruction),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            if (b.canTrainShips) ...[
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _actionChip(
                        'Caza\n${Balance.shipCazaMineralCost}💎/${Balance.shipCazaEnergyCost}☀',
                        () => game.trainUnit(UnitKind.shipCaza),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Interceptor\n${Balance.shipInterceptorMineralCost}💎/${Balance.shipInterceptorEnergyCost}☀',
                        () => game.trainUnit(UnitKind.shipInterceptor),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Fragata\n${Balance.shipFragataMineralCost}💎/${Balance.shipFragataEnergyCost}☀',
                        () => game.trainUnit(UnitKind.shipFragata),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Crucero\n${Balance.shipCruceroMineralCost}💎/${Balance.shipCruceroEnergyCost}☀',
                        () => game.trainUnit(UnitKind.shipCrucero),
                      ),
                      const SizedBox(width: 4),
                      _actionChip(
                        'Acorazado\n${Balance.shipAcorazadoMineralCost}💎/${Balance.shipAcorazadoEnergyCost}☀',
                        () => game.trainUnit(UnitKind.shipAcorazado),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: units.length.clamp(0, 12),
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, i) {
          final u = units[i];
          return _portrait(
            label: u.kind.shortEs,
            hp: 'HP ${u.hp}/${u.maxHp}',
            progress: u.hp / u.maxHp,
            subtitle: u.isWorker ? _jobLabel(u) : u.kind.labelEs,
          );
        },
      ),
    );
  }

  String _jobLabel(GameUnit u) {
    switch (u.job) {
      case WorkerJob.idle:
        return 'Inactivo';
      case WorkerJob.moving:
        return 'Moviendo';
      case WorkerJob.harvesting:
        return 'Recolectando';
      case WorkerJob.carrying:
        return 'Transportando';
      case WorkerJob.depositing:
        return 'Depositando';
      case WorkerJob.building:
        return 'Construyendo';
      case WorkerJob.holding:
        return 'Manteniendo';
    }
  }

  Widget _portrait({
    required String label,
    required String hp,
    required double progress,
    required String subtitle,
  }) {
    return Container(
      width: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F28),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _mineralBlue),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _mineralBlue,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: Colors.black,
            color: _energyGreen,
          ),
          Text(hp, style: const TextStyle(color: Colors.white70, fontSize: 8)),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F28),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _energyGreen),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({required this.game});
  final RtsGame game;

  @override
  Widget build(BuildContext context) {
    final building = game.selectedUnits.isNotEmpty;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1.15,
      children: [
        _cmd('MOVER', Icons.arrow_upward, const Color(0xFF00AEEF), () {
          game.showToast('Toca el mapa para mover');
        }),
        _cmd('ATACAR', Icons.gps_fixed, const Color(0xFFFF4444), game.commandAttackStub),
        _cmd('MANTENER', Icons.shield, const Color(0xFFFFD60A), game.commandHold),
        _cmd('PATRULLA', Icons.sync, const Color(0xFF39FF14), game.commandPatrolStub),
        _cmd(
          'CONSTRUIR',
          Icons.build,
          const Color(0xFFAAAAAA),
          building ? () => _showBuildSheet(context) : () {
            game.showToast('Selecciona obreros');
          },
        ),
        _cmd('ESPECIAL', Icons.auto_awesome, const Color(0xFFB388FF), game.commandSpecialStub),
      ],
    );
  }

  Widget _cmd(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F28),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.7)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuildSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151920),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'CONSTRUIR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildOption(
                  ctx,
                  'Panel solar',
                  '${Balance.solarPanelMineralCost} minerales — +${Balance.energyPerPanelPerMin.toInt()} Energía/min (cualquier sitio)',
                  () => game.enterBuildMode(BuildMode.solarPanel),
                ),
                _buildOption(
                  ctx,
                  'Depósito',
                  '${Balance.supplyDepotMineralCost} minerales — +${Balance.supplyDepotSupply} suministro',
                  () => game.enterBuildMode(BuildMode.supplyDepot),
                ),
                _buildOption(
                  ctx,
                  'Cuartel',
                  '${Balance.barracksMineralCost} minerales — produce tropas/vehículos',
                  () => game.enterBuildMode(BuildMode.barracks),
                ),
                _buildOption(
                  ctx,
                  'Puesto avanzado',
                  '${Balance.outpostMineralCost} minerales — depósito extra',
                  () => game.enterBuildMode(BuildMode.outpost),
                ),
                _buildOption(
                  ctx,
                  'Centro de Mando',
                  '${Balance.ccMineralCost} minerales — expansión',
                  () => game.enterBuildMode(BuildMode.commandCenter),
                ),
                _buildOption(
                  ctx,
                  'Laboratorio',
                  '${Balance.laboratoryMineralCost} minerales / ${Balance.laboratoryEnergyCost} Energía — investigación',
                  () => game.enterBuildMode(BuildMode.laboratory),
                ),
                _buildOption(
                  ctx,
                  game.research.shipConstructionUnlocked
                      ? 'Puerto estelar'
                      : 'Puerto estelar (bloqueado)',
                  game.research.shipConstructionUnlocked
                      ? '${Balance.starportMineralCost} minerales / ${Balance.starportEnergyCost} Energía — produce naves'
                      : 'Requiere tech «Construcción de naves»',
                  () => game.enterBuildMode(BuildMode.starport),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext ctx,
    String title,
    String subtitle,
    VoidCallback onPick,
  ) {
    return ListTile(
      dense: true,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      onTap: () {
        Navigator.pop(ctx);
        onPick();
      },
    );
  }
}
