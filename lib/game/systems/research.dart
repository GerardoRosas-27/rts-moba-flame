import '../balance.dart';
import '../enums.dart';
import '../components/building.dart';

class ResearchItem {
  ResearchItem({
    required this.kind,
    required this.totalSeconds,
    required this.source,
    required this.remaining,
  });

  final TechKind kind;
  final double totalSeconds;
  double remaining;
  final Building source;

  factory ResearchItem.tech(TechKind kind, Building source) {
    final secs = Balance.researchSecondsOf(kind);
    return ResearchItem(
      kind: kind,
      totalSeconds: secs,
      source: source,
      remaining: secs,
    );
  }
}

/// Cola de investigación global (un laboratorio a la vez).
class ResearchQueue {
  final List<ResearchItem> items = [];
  final Set<TechKind> unlocked = {};

  int get length => items.length;
  bool get isBusy => items.isNotEmpty;
  bool get isEmpty => items.isEmpty;

  bool isUnlocked(TechKind kind) => unlocked.contains(kind);

  bool get shipConstructionUnlocked =>
      isUnlocked(TechKind.shipConstruction);

  bool get archersUnlocked => isUnlocked(TechKind.combatArchers);
  bool get vehiclesUnlocked => isUnlocked(TechKind.combatVehicles);
  bool get mechsUnlocked => isUnlocked(TechKind.combatMechs);

  bool isGroupUnlocked(BattleGroupKind group) {
    final tech = group.requiredTech;
    if (tech == null) return true;
    return isUnlocked(tech);
  }

  bool canResearch(TechKind kind) {
    if (isUnlocked(kind)) return false;
    if (items.any((e) => e.kind == kind)) return false;
    final pre = kind.prerequisite;
    if (pre != null && !isUnlocked(pre)) return false;
    return true;
  }

  String? blockedReason(TechKind kind) {
    if (isUnlocked(kind)) return 'Ya investigado';
    final pre = kind.prerequisite;
    if (pre != null && !isUnlocked(pre)) {
      return 'Requiere «${pre.labelEs}» primero';
    }
    if (isBusy) return 'Investigación en curso';
    return null;
  }

  bool enqueue(ResearchItem item) {
    if (isBusy) return false;
    if (!canResearch(item.kind)) return false;
    items.add(item);
    return true;
  }

  void cancel() {
    items.clear();
  }

  List<ResearchItem> update(double dt) {
    if (items.isEmpty) return const [];
    final done = <ResearchItem>[];
    items.first.remaining -= dt;
    while (items.isNotEmpty && items.first.remaining <= 0) {
      final item = items.removeAt(0);
      unlocked.add(item.kind);
      done.add(item);
    }
    return done;
  }

  /// Snapshot for battle (tech unlocks only).
  Set<TechKind> snapshotUnlocked() => Set.of(unlocked);
}
