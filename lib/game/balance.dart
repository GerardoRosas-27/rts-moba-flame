import 'enums.dart';

/// Feel numbers for v0.3.0 — Laboratorio + tech naves + Puerto estelar.
class Balance {
  // --- Start ---
  static const int startMinerals = 150;
  static const int startEnergy = 0;
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
  static const int workerEnergyCost = 0;
  static const int workerSupplyCost = 1;
  static const double workerTrainSeconds = 12;
  static const double workerSpeed = 95;
  static const double workerRadius = 14;
  static const int workerMaxHp = 45;
  static const int mineralCarryAmount = 8;
  static const double harvestGatherSeconds = 1.6;
  static const double harvestDepositRange = 48;
  static const double harvestNodeRange = 36;

  // --- Infantry ---
  static const int infantryFrogMineralCost = 50;
  static const int infantryFrogEnergyCost = 0;
  static const int infantryFrogSupplyCost = 1;
  static const double infantryFrogTrainSeconds = 15;
  static const double infantryFrogSpeed = 105;
  static const double infantryFrogRadius = 14;
  static const int infantryFrogMaxHp = 60;

  static const int infantryBeeMineralCost = 50;
  static const int infantryBeeEnergyCost = 15;
  static const int infantryBeeSupplyCost = 1;
  static const double infantryBeeTrainSeconds = 16;
  static const double infantryBeeSpeed = 110;
  static const double infantryBeeRadius = 14;
  static const int infantryBeeMaxHp = 55;

  // --- Rover ---
  static const int roverMineralCost = 100;
  static const int roverEnergyCost = 25;
  static const int roverSupplyCost = 2;
  static const double roverTrainSeconds = 25;
  static const double roverSpeed = 120;
  static const double roverRadius = 20;
  static const int roverMaxHp = 120;

  // --- Mech ---
  static const int mechMineralCost = 150;
  static const int mechEnergyCost = 50;
  static const int mechSupplyCost = 3;
  static const double mechTrainSeconds = 35;
  static const double mechSpeed = 70;
  static const double mechRadius = 26;
  static const int mechMaxHp = 220;

  // --- Ships (tier 1→5) ---
  static const int shipCazaMineralCost = 75;
  static const int shipCazaEnergyCost = 25;
  static const int shipCazaSupplyCost = 2;
  static const double shipCazaTrainSeconds = 20;
  static const double shipCazaSpeed = 140;
  static const double shipCazaRadius = 16;
  static const int shipCazaMaxHp = 80;

  static const int shipInterceptorMineralCost = 100;
  static const int shipInterceptorEnergyCost = 40;
  static const int shipInterceptorSupplyCost = 2;
  static const double shipInterceptorTrainSeconds = 25;
  static const double shipInterceptorSpeed = 155;
  static const double shipInterceptorRadius = 18;
  static const int shipInterceptorMaxHp = 100;

  static const int shipFragataMineralCost = 150;
  static const int shipFragataEnergyCost = 60;
  static const int shipFragataSupplyCost = 3;
  static const double shipFragataTrainSeconds = 35;
  static const double shipFragataSpeed = 110;
  static const double shipFragataRadius = 22;
  static const int shipFragataMaxHp = 160;

  static const int shipCruceroMineralCost = 225;
  static const int shipCruceroEnergyCost = 90;
  static const int shipCruceroSupplyCost = 4;
  static const double shipCruceroTrainSeconds = 50;
  static const double shipCruceroSpeed = 90;
  static const double shipCruceroRadius = 28;
  static const int shipCruceroMaxHp = 280;

  static const int shipAcorazadoMineralCost = 350;
  static const int shipAcorazadoEnergyCost = 150;
  static const int shipAcorazadoSupplyCost = 6;
  static const double shipAcorazadoTrainSeconds = 75;
  static const double shipAcorazadoSpeed = 65;
  static const double shipAcorazadoRadius = 36;
  static const int shipAcorazadoMaxHp = 450;

  // --- Tech ---
  static const int techShipConstructionMineralCost = 150;
  static const int techShipConstructionEnergyCost = 100;
  static const double techShipConstructionSeconds = 60;

  // --- Resources ---
  static const int mineralNodeAmount = 1500;
  static const int mineralNodesNearBase = 8;
  static const int mineralNodesExpansion = 6;

  /// Energía pasiva generada por cada Panel solar completo.
  static const double energyPerPanelPerMin = 12;

  // --- Buildings ---
  static const int ccMineralCost = 400;
  static const int ccEnergyCost = 0;
  static const int ccSupplyProvided = 10;
  static const double ccBuildSeconds = 60;
  static const double ccRadius = 64;
  static const int ccMaxHp = 1500;

  static const int solarPanelMineralCost = 100;
  static const int solarPanelEnergyCost = 0;
  static const double solarPanelBuildSeconds = 30;
  static const double solarPanelRadius = 42;
  static const int solarPanelMaxHp = 500;

  /// Máximo de obreros asignados al colocar / reanudar una obra.
  static const int maxBuildersPerSite = 3;

  static const int supplyDepotMineralCost = 100;
  static const int supplyDepotEnergyCost = 0;
  static const int supplyDepotSupply = 8;
  static const double supplyDepotBuildSeconds = 20;
  static const double supplyDepotRadius = 36;
  static const int supplyDepotMaxHp = 400;

  static const int barracksMineralCost = 150;
  static const int barracksEnergyCost = 0;
  static const double barracksBuildSeconds = 35;
  static const double barracksRadius = 48;
  static const int barracksMaxHp = 800;

  static const int outpostMineralCost = 150;
  static const int outpostEnergyCost = 0;
  static const int outpostSupply = 0;
  static const double outpostBuildSeconds = 40;
  static const double outpostRadius = 40;
  static const int outpostMaxHp = 600;

  static const int laboratoryMineralCost = 150;
  static const int laboratoryEnergyCost = 50;
  static const double laboratoryBuildSeconds = 40;
  static const double laboratoryRadius = 44;
  static const int laboratoryMaxHp = 700;

  static const int starportMineralCost = 200;
  static const int starportEnergyCost = 100;
  static const double starportBuildSeconds = 50;
  static const double starportRadius = 56;
  static const int starportMaxHp = 1000;

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
      case UnitKind.shipCaza:
        return shipCazaMineralCost;
      case UnitKind.shipInterceptor:
        return shipInterceptorMineralCost;
      case UnitKind.shipFragata:
        return shipFragataMineralCost;
      case UnitKind.shipCrucero:
        return shipCruceroMineralCost;
      case UnitKind.shipAcorazado:
        return shipAcorazadoMineralCost;
    }
  }

  static int energyCostOf(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return workerEnergyCost;
      case UnitKind.infantryFrog:
        return infantryFrogEnergyCost;
      case UnitKind.infantryBee:
        return infantryBeeEnergyCost;
      case UnitKind.rover:
        return roverEnergyCost;
      case UnitKind.mech:
        return mechEnergyCost;
      case UnitKind.shipCaza:
        return shipCazaEnergyCost;
      case UnitKind.shipInterceptor:
        return shipInterceptorEnergyCost;
      case UnitKind.shipFragata:
        return shipFragataEnergyCost;
      case UnitKind.shipCrucero:
        return shipCruceroEnergyCost;
      case UnitKind.shipAcorazado:
        return shipAcorazadoEnergyCost;
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
      case UnitKind.shipCaza:
        return shipCazaSupplyCost;
      case UnitKind.shipInterceptor:
        return shipInterceptorSupplyCost;
      case UnitKind.shipFragata:
        return shipFragataSupplyCost;
      case UnitKind.shipCrucero:
        return shipCruceroSupplyCost;
      case UnitKind.shipAcorazado:
        return shipAcorazadoSupplyCost;
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
      case UnitKind.shipCaza:
        return shipCazaTrainSeconds;
      case UnitKind.shipInterceptor:
        return shipInterceptorTrainSeconds;
      case UnitKind.shipFragata:
        return shipFragataTrainSeconds;
      case UnitKind.shipCrucero:
        return shipCruceroTrainSeconds;
      case UnitKind.shipAcorazado:
        return shipAcorazadoTrainSeconds;
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
      case UnitKind.shipCaza:
        return shipCazaRadius;
      case UnitKind.shipInterceptor:
        return shipInterceptorRadius;
      case UnitKind.shipFragata:
        return shipFragataRadius;
      case UnitKind.shipCrucero:
        return shipCruceroRadius;
      case UnitKind.shipAcorazado:
        return shipAcorazadoRadius;
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
      case UnitKind.shipCaza:
        return shipCazaSpeed;
      case UnitKind.shipInterceptor:
        return shipInterceptorSpeed;
      case UnitKind.shipFragata:
        return shipFragataSpeed;
      case UnitKind.shipCrucero:
        return shipCruceroSpeed;
      case UnitKind.shipAcorazado:
        return shipAcorazadoSpeed;
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
      case UnitKind.shipCaza:
        return shipCazaMaxHp;
      case UnitKind.shipInterceptor:
        return shipInterceptorMaxHp;
      case UnitKind.shipFragata:
        return shipFragataMaxHp;
      case UnitKind.shipCrucero:
        return shipCruceroMaxHp;
      case UnitKind.shipAcorazado:
        return shipAcorazadoMaxHp;
    }
  }

  static int techMineralCostOf(TechKind kind) {
    switch (kind) {
      case TechKind.shipConstruction:
        return techShipConstructionMineralCost;
    }
  }

  static int techEnergyCostOf(TechKind kind) {
    switch (kind) {
      case TechKind.shipConstruction:
        return techShipConstructionEnergyCost;
    }
  }

  static double researchSecondsOf(TechKind kind) {
    switch (kind) {
      case TechKind.shipConstruction:
        return techShipConstructionSeconds;
    }
  }
}
