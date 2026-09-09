/// Feel numbers for v0.1 — construction & harvesting only.
/// Tuned for a StarCraft-like early-game loop on mobile.
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
  static const double workerSpeed = 95; // px/s
  static const double workerRadius = 10;
  static const int workerMaxHp = 45;
  static const int mineralCarryAmount = 8;
  static const int gasCarryAmount = 6;
  static const double harvestGatherSeconds = 1.6;
  static const double harvestDepositRange = 48;
  static const double harvestNodeRange = 36;

  // --- Resources ---
  static const int mineralNodeAmount = 1500;
  static const int gasGeyserAmount = 2500;
  static const int mineralNodesNearBase = 8;
  static const int mineralNodesExpansion = 6;

  // --- Buildings (mineral / gas / supply / buildSeconds) ---
  static const int ccMineralCost = 400;
  static const int ccGasCost = 0;
  static const int ccSupplyProvided = 10;
  static const double ccBuildSeconds = 60;
  static const double ccRadius = 56;
  static const int ccMaxHp = 1500;

  static const int refineryMineralCost = 100;
  static const int refineryGasCost = 0;
  static const double refineryBuildSeconds = 30;
  static const double refineryRadius = 36;
  static const int refineryMaxHp = 500;
  static const int refineryWorkerSlots = 3;

  static const int supplyDepotMineralCost = 100;
  static const int supplyDepotGasCost = 0;
  static const int supplyDepotSupply = 8;
  static const double supplyDepotBuildSeconds = 20;
  static const double supplyDepotRadius = 28;
  static const int supplyDepotMaxHp = 400;

  static const int barracksMineralCost = 150;
  static const int barracksGasCost = 0;
  static const double barracksBuildSeconds = 35;
  static const double barracksRadius = 40;
  static const int barracksMaxHp = 800;

  static const int outpostMineralCost = 150;
  static const int outpostGasCost = 0;
  static const int outpostSupply = 0;
  static const double outpostBuildSeconds = 40;
  static const double outpostRadius = 40;
  static const int outpostMaxHp = 600;

  // --- Production ---
  static const int maxQueueSlots = 6;

  // --- Economy rate display (rolling window) ---
  static const double harvestRateWindowSeconds = 60;
}
