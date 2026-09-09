import '../balance.dart';

/// Tracks minerals, gas, supply and rolling harvest rates.
class Economy {
  int minerals;
  int gas;
  int supplyUsed;
  int supplyMax;

  final List<(double time, int amount)> _mineralDeposits = [];
  final List<(double time, int amount)> _gasDeposits = [];
  double _clock = 0;

  Economy({
    this.minerals = Balance.startMinerals,
    this.gas = Balance.startGas,
    this.supplyUsed = 0,
    this.supplyMax = Balance.commandCenterSupply,
  });

  bool canAfford({int mineral = 0, int gasCost = 0, int supply = 0}) {
    if (minerals < mineral) return false;
    if (gas < gasCost) return false;
    if (supply > 0 && supplyUsed + supply > supplyMax) return false;
    return true;
  }

  bool spend({int mineral = 0, int gasCost = 0, int supply = 0}) {
    if (!canAfford(mineral: mineral, gasCost: gasCost, supply: supply)) {
      return false;
    }
    minerals -= mineral;
    gas -= gasCost;
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

  void depositGas(int amount) {
    gas += amount;
    _gasDeposits.add((_clock, amount));
  }

  void update(double dt) {
    _clock += dt;
    final cutoff = _clock - Balance.harvestRateWindowSeconds;
    _mineralDeposits.removeWhere((e) => e.$1 < cutoff);
    _gasDeposits.removeWhere((e) => e.$1 < cutoff);
  }

  int get mineralRatePerMin {
    final sum = _mineralDeposits.fold<int>(0, (a, e) => a + e.$2);
    return (sum * (60 / Balance.harvestRateWindowSeconds)).round();
  }

  int get gasRatePerMin {
    final sum = _gasDeposits.fold<int>(0, (a, e) => a + e.$2);
    return (sum * (60 / Balance.harvestRateWindowSeconds)).round();
  }
}
