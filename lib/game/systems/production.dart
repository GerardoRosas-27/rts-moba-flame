import '../balance.dart';
import '../enums.dart';
import '../components/building.dart';

class QueueItem {
  QueueItem({
    required this.kind,
    required this.totalSeconds,
    required this.source,
    required this.remaining,
  });

  final UnitKind kind;
  final double totalSeconds;
  double remaining;
  final Building source;

  factory QueueItem.worker(Building source) {
    return QueueItem(
      kind: UnitKind.worker,
      totalSeconds: Balance.workerTrainSeconds,
      source: source,
      remaining: Balance.workerTrainSeconds,
    );
  }
}

class ProductionQueue {
  final List<QueueItem> items = [];

  int get length => items.length;
  bool get isFull => items.length >= Balance.maxQueueSlots;
  bool get isEmpty => items.isEmpty;

  bool enqueue(QueueItem item) {
    if (isFull) return false;
    items.add(item);
    return true;
  }

  void cancelAt(int index) {
    if (index < 0 || index >= items.length) return;
    items.removeAt(index);
  }

  List<QueueItem> update(double dt) {
    if (items.isEmpty) return const [];
    final done = <QueueItem>[];
    items.first.remaining -= dt;
    while (items.isNotEmpty && items.first.remaining <= 0) {
      done.add(items.removeAt(0));
    }
    return done;
  }
}
