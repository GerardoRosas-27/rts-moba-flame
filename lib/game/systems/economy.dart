import '../balance.dart';

/// Tracks minerals, energía, supply and rolling rates.
class Economy {
  int minerals;
  int energy;
  int supplyUsed;
  int supplyMax;

  final List<(double time, int amount)> _mineralDeposits = [];
  final List<(double time, int amount)> _energyDeposits = [];
  double _clock = 0;
  double _energyAccumulator = 0;

  Economy({
    this.minerals = Balance.startMinerals,
    this.energy = Balance.startEnergy,
    this.supplyUsed = 0,
    this.supplyMax = Balance.commandCenterSupply,
  });

  bool canAfford({int mineral = 0, int energyCost = 0, int supply = 0}) {
    if (minerals < mineral) return false;
    if (energy < energyCost) return false;
    if (supply > 0 && supplyUsed + supply > supplyMax) return false;
    return true;
  }

  bool spend({int mineral = 0, int energyCost = 0, int supply = 0}) {
    if (!canAfford(mineral: mineral, energyCost: energyCost, supply: supply)) {
      return false;
    }
    minerals -= mineral;
    energy -= energyCost;
    supplyUsed += supply;
    return true;
  }

  void refundSupply(int amount) {
    supplyUsed = (supplyUsed - amount).clamp(0, supplyMax + 999);
  }

  void addSupplyMax(int amount) => supplyMax += amount;

  void depositMineral(int amount) {
    minerals += amount;
    _mineralDeposits.add((_clock, amount));
  }

  void depositEnergy(int amount) {
    if (amount <= 0) return;
    energy += amount;
    _energyDeposits.add((_clock, amount));
  }

  /// Generación pasiva: [panelCount] paneles solares completos.
  void tickPassiveEnergy(double dt, int panelCount) {
    if (panelCount <= 0) return;
    _energyAccumulator +=
        panelCount * (Balance.energyPerPanelPerMin / 60.0) * dt;
    while (_energyAccumulator >= 1) {
      final whole = _energyAccumulator.floor();
      _energyAccumulator -= whole;
      depositEnergy(whole);
    }
  }

  void update(double dt) {
    _clock += dt;
    final cutoff = _clock - Balance.harvestRateWindowSeconds;
    _mineralDeposits.removeWhere((e) => e.$1 < cutoff);
    _energyDeposits.removeWhere((e) => e.$1 < cutoff);
  }

  int get mineralRatePerMin {
    final sum = _mineralDeposits.fold<int>(0, (a, e) => a + e.$2);
    return (sum * (60 / Balance.harvestRateWindowSeconds)).round();
  }

  int get energyRatePerMin {
    final sum = _energyDeposits.fold<int>(0, (a, e) => a + e.$2);
    return (sum * (60 / Balance.harvestRateWindowSeconds)).round();
  }
}
