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

/// Cola de investigación global (un laboratorio a la vez en v0.3).
class ResearchQueue {
  final List<ResearchItem> items = [];
  final Set<TechKind> unlocked = {};

  int get length => items.length;
  bool get isBusy => items.isNotEmpty;
  bool get isEmpty => items.isEmpty;

  bool isUnlocked(TechKind kind) => unlocked.contains(kind);

  bool get shipConstructionUnlocked =>
      isUnlocked(TechKind.shipConstruction);

  bool enqueue(ResearchItem item) {
    if (isBusy) return false;
    if (unlocked.contains(item.kind)) return false;
    // No duplicar la misma tech en cola.
    if (items.any((e) => e.kind == item.kind)) return false;
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
}
