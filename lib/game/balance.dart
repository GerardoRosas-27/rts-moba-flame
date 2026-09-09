import 'enums.dart';

/// Feel numbers for v0.2 — economía v0.1 + producción militar del Cuartel.
class Balance {
  // --- Start ---
  static const int startMinerals = 150;
  static const int startGas = 0;
  static const int startWorkers = 5;
  static const int commandCenterSupply = 10;

  // --- Map ---
  static const double mapWidth = 2400;
  static const double mapHeight = 1800;
  static const double cameraMinZoom = 0.45;
  static const double cameraMaxZoom = 1.6;
  static const double cameraStartZoom = 0.85;

  // --- Worker ---
  static const int workerMineralCost = 50;
  static const int workerGasCost = 0;
  static const int workerSupplyCost = 1;
  static const double workerTrainSeconds = 12;
  static const double workerSpeed = 95;
  static const double workerRadius = 14;
  static const int workerMaxHp = 45;
  static const int mineralCarryAmount = 8;
  static const int gasCarryAmount = 6;
  static const double harvestGatherSeconds = 1.6;
  static const double harvestDepositRange = 48;
  static const double harvestNodeRange = 36;

  // --- Infantry ---
  static const int infantryFrogMineralCost = 50;
  static const int infantryFrogGasCost = 0;
  static const int infantryFrogSupplyCost = 1;
  static const double infantryFrogTrainSeconds = 15;
  static const double infantryFrogSpeed = 105;
  static const double infantryFrogRadius = 14;
  static const int infantryFrogMaxHp = 60;

  static const int infantryBeeMineralCost = 50;
  static const int infantryBeeGasCost = 15;
  static const int infantryBeeSupplyCost = 1;
  static const double infantryBeeTrainSeconds = 16;
  static const double infantryBeeSpeed = 110;
  static const double infantryBeeRadius = 14;
  static const int infantryBeeMaxHp = 55;

  // --- Rover ---
  static const int roverMineralCost = 100;
  static const int roverGasCost = 25;
  static const int roverSupplyCost = 2;
  static const double roverTrainSeconds = 25;
  static const double roverSpeed = 120;
  static const double roverRadius = 20;
  static const int roverMaxHp = 120;

  // --- Mech ---
  static const int mechMineralCost = 150;
  static const int mechGasCost = 50;
  static const int mechSupplyCost = 3;
  static const double mechTrainSeconds = 35;
  static const double mechSpeed = 70;
  static const double mechRadius = 26;
  static const int mechMaxHp = 220;

  // --- Resources ---
  static const int mineralNodeAmount = 1500;
  static const int gasGeyserAmount = 2500;
  static const int mineralNodesNearBase = 8;
  static const int mineralNodesExpansion = 6;

  // --- Buildings ---
  static const int ccMineralCost = 400;
  static const int ccGasCost = 0;
  static const int ccSupplyProvided = 10;
  static const double ccBuildSeconds = 60;
  static const double ccRadius = 64;
  static const int ccMaxHp = 1500;

  static const int refineryMineralCost = 100;
  static const int refineryGasCost = 0;
  static const double refineryBuildSeconds = 30;
  static const double refineryRadius = 42;
  static const int refineryMaxHp = 500;
  static const int refineryWorkerSlots = 3;

  static const int supplyDepotMineralCost = 100;
  static const int supplyDepotGasCost = 0;
  static const int supplyDepotSupply = 8;
  static const double supplyDepotBuildSeconds = 20;
  static const double supplyDepotRadius = 36;
  static const int supplyDepotMaxHp = 400;

  static const int barracksMineralCost = 150;
  static const int barracksGasCost = 0;
  static const double barracksBuildSeconds = 35;
  static const double barracksRadius = 48;
  static const int barracksMaxHp = 800;

  static const int outpostMineralCost = 150;
  static const int outpostGasCost = 0;
  static const int outpostSupply = 0;
  static const double outpostBuildSeconds = 40;
  static const double outpostRadius = 40;
  static const int outpostMaxHp = 600;

  static const int maxQueueSlots = 6;
  static const double harvestRateWindowSeconds = 60;

  static int mineralCostOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerMineralCost;
      case UnitKind.infantryFrog:
        return infantryFrogMineralCost;
      case UnitKind.infantryBee:
        return infantryBeeMineralCost;
      case UnitKind.rover:
        return roverMineralCost;
      case UnitKind.mech:
        return mechMineralCost;
    }
  }

  static int gasCostOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerGasCost;
      case UnitKind.infantryFrog:
        return infantryFrogGasCost;
      case UnitKind.infantryBee:
        return infantryBeeGasCost;
      case UnitKind.rover:
        return roverGasCost;
      case UnitKind.mech:
        return mechGasCost;
    }
  }

  static int supplyCostOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerSupplyCost;
      case UnitKind.infantryFrog:
        return infantryFrogSupplyCost;
      case UnitKind.infantryBee:
        return infantryBeeSupplyCost;
      case UnitKind.rover:
        return roverSupplyCost;
      case UnitKind.mech:
        return mechSupplyCost;
    }
  }

  static double trainSecondsOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerTrainSeconds;
      case UnitKind.infantryFrog:
        return infantryFrogTrainSeconds;
      case UnitKind.infantryBee:
        return infantryBeeTrainSeconds;
      case UnitKind.rover:
        return roverTrainSeconds;
      case UnitKind.mech:
        return mechTrainSeconds;
    }
  }

  static double radiusOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerRadius;
      case UnitKind.infantryFrog:
        return infantryFrogRadius;
      case UnitKind.infantryBee:
        return infantryBeeRadius;
      case UnitKind.rover:
        return roverRadius;
      case UnitKind.mech:
        return mechRadius;
    }
  }

  static double speedOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerSpeed;
      case UnitKind.infantryFrog:
        return infantryFrogSpeed;
      case UnitKind.infantryBee:
        return infantryBeeSpeed;
      case UnitKind.rover:
        return roverSpeed;
      case UnitKind.mech:
        return mechSpeed;
    }
  }

  static int maxHpOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerMaxHp;
      case UnitKind.infantryFrog:
        return infantryFrogMaxHp;
      case UnitKind.infantryBee:
        return infantryBeeMaxHp;
      case UnitKind.rover:
        return roverMaxHp;
      case UnitKind.mech:
        return mechMaxHp;
    }
  }
}
