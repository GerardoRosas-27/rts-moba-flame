enum ResourceKind { mineral }

enum BuildingKind {
  commandCenter,
  solarPanel,
  supplyDepot,
  barracks,
  outpost,
  laboratory,
  starport,
}

enum UnitKind {
  worker,
  infantryFrog,
  infantryBee,
  rover,
  mech,
  shipCaza,
  shipInterceptor,
  shipFragata,
  shipCrucero,
  shipAcorazado,
}

/// Sciences tree (Asedio progression). Order: Soldados (start) → Arqueros →
/// Vehículos → Mechs → Naves (shipConstruction + Starport).
enum TechKind {
  combatArchers,
  combatVehicles,
  combatMechs,
  shipConstruction,
}

enum CommandAction {
  move,
  attack,
  hold,
  patrol,
  build,
  special,
}

enum BuildMode {
  none,
  solarPanel,
  supplyDepot,
  barracks,
  outpost,
  commandCenter,
  laboratory,
  starport,
}

enum WorkerJob {
  idle,
  moving,
  harvesting,
  carrying,
  depositing,
  building,
  holding,
}

/// Up to 5 battle group types unlocked by research.
enum BattleGroupKind {
  soldados,
  arqueros,
  vehiculos,
  mechs,
  naves,
}

enum BattleCommand {
  cargar,
  mantener,
  retirar,
  fuegoConcentrado,
}

enum BattleOutcome {
  ongoing,
  victory,
  defeat,
  retreat,
}

extension BuildingKindLabel on BuildingKind {
  String get labelEs {
    switch (this) {
      case BuildingKind.commandCenter:
        return 'Centro de Mando';
      case BuildingKind.solarPanel:
        return 'Panel solar';
      case BuildingKind.supplyDepot:
        return 'Depósito';
      case BuildingKind.barracks:
        return 'Cuartel';
      case BuildingKind.outpost:
        return 'Puesto Avanzado';
      case BuildingKind.laboratory:
        return 'Laboratorio';
      case BuildingKind.starport:
        return 'Puerto estelar';
    }
  }

  String get shortEs {
    switch (this) {
      case BuildingKind.commandCenter:
        return 'CC';
      case BuildingKind.solarPanel:
        return 'SOL';
      case BuildingKind.supplyDepot:
        return 'DEP';
      case BuildingKind.barracks:
        return 'CUA';
      case BuildingKind.outpost:
        return 'PA';
      case BuildingKind.laboratory:
        return 'LAB';
      case BuildingKind.starport:
        return 'PUE';
    }
  }

  String get kitName {
    switch (this) {
      case BuildingKind.commandCenter:
        return 'Base_Large';
      case BuildingKind.solarPanel:
        return 'SolarPanel_Structure';
      case BuildingKind.supplyDepot:
        return 'GeodesicDome';
      case BuildingKind.barracks:
        return 'Building_L';
      case BuildingKind.outpost:
        return 'House_Cylinder';
      case BuildingKind.laboratory:
        return 'Roof_Radar';
      case BuildingKind.starport:
        return 'House_Open';
    }
  }
}

extension UnitKindLabel on UnitKind {
  String get labelEs {
    switch (this) {
      case UnitKind.worker:
        return 'Obrero';
      case UnitKind.infantryFrog:
        return 'Soldado';
      case UnitKind.infantryBee:
        return 'Arquero';
      case UnitKind.rover:
        return 'Rover';
      case UnitKind.mech:
        return 'Mech';
      case UnitKind.shipCaza:
        return 'Caza';
      case UnitKind.shipInterceptor:
        return 'Interceptor';
      case UnitKind.shipFragata:
        return 'Fragata';
      case UnitKind.shipCrucero:
        return 'Crucero';
      case UnitKind.shipAcorazado:
        return 'Acorazado';
    }
  }

  String get shortEs {
    switch (this) {
      case UnitKind.worker:
        return 'OBR';
      case UnitKind.infantryFrog:
        return 'SOL';
      case UnitKind.infantryBee:
        return 'ARQ';
      case UnitKind.rover:
        return 'ROV';
      case UnitKind.mech:
        return 'MEC';
      case UnitKind.shipCaza:
        return 'CAZ';
      case UnitKind.shipInterceptor:
        return 'INT';
      case UnitKind.shipFragata:
        return 'FRA';
      case UnitKind.shipCrucero:
        return 'CRU';
      case UnitKind.shipAcorazado:
        return 'ACO';
    }
  }

  String get kitName {
    switch (this) {
      case UnitKind.worker:
        return 'Astronaut_RaeTheRedPanda';
      case UnitKind.infantryFrog:
        return 'Astronaut_FinnTheFrog';
      case UnitKind.infantryBee:
        return 'Astronaut_BarbaraTheBee';
      case UnitKind.rover:
        return 'Rover_1';
      case UnitKind.mech:
        return 'Mech_FinnTheFrog';
      case UnitKind.shipCaza:
        return 'Spaceship_RaeTheRedPanda';
      case UnitKind.shipInterceptor:
        return 'Spaceship_FinnTheFrog';
      case UnitKind.shipFragata:
        return 'Spaceship_BarbaraTheBee';
      case UnitKind.shipCrucero:
        return 'Spaceship_FernandoTheFlamingo';
      case UnitKind.shipAcorazado:
        return 'Spaceship_FernandoTheFlamingo';
    }
  }

  bool get canHarvest => this == UnitKind.worker;
  bool get canBuild => this == UnitKind.worker;
  bool get isShip =>
      this == UnitKind.shipCaza ||
      this == UnitKind.shipInterceptor ||
      this == UnitKind.shipFragata ||
      this == UnitKind.shipCrucero ||
      this == UnitKind.shipAcorazado;
  bool get isMilitary => this != UnitKind.worker;
}

extension TechKindLabel on TechKind {
  String get labelEs {
    switch (this) {
      case TechKind.combatArchers:
        return 'Arqueros / choque';
      case TechKind.combatVehicles:
        return 'Vehículos terrestres';
      case TechKind.combatMechs:
        return 'Mechs de asedio';
      case TechKind.shipConstruction:
        return 'Construcción de naves';
    }
  }

  String get shortEs {
    switch (this) {
      case TechKind.combatArchers:
        return 'ARQ';
      case TechKind.combatVehicles:
        return 'VEH';
      case TechKind.combatMechs:
        return 'MEC';
      case TechKind.shipConstruction:
        return 'NAV';
    }
  }

  String get descEs {
    switch (this) {
      case TechKind.combatArchers:
        return 'Desbloquea grupo Arqueros en batalla y Cuartel';
      case TechKind.combatVehicles:
        return 'Desbloquea grupo Rovers en batalla y Cuartel';
      case TechKind.combatMechs:
        return 'Desbloquea grupo Mechs en batalla y Cuartel';
      case TechKind.shipConstruction:
        return 'Desbloquea Puerto estelar y grupo Naves en batalla';
    }
  }

  /// Soft chain for Sciences UI order.
  TechKind? get prerequisite {
    switch (this) {
      case TechKind.combatArchers:
        return null;
      case TechKind.combatVehicles:
        return TechKind.combatArchers;
      case TechKind.combatMechs:
        return TechKind.combatVehicles;
      case TechKind.shipConstruction:
        return TechKind.combatMechs;
    }
  }
}

extension BattleGroupKindLabel on BattleGroupKind {
  String get labelEs {
    switch (this) {
      case BattleGroupKind.soldados:
        return 'Soldados';
      case BattleGroupKind.arqueros:
        return 'Arqueros';
      case BattleGroupKind.vehiculos:
        return 'Rovers';
      case BattleGroupKind.mechs:
        return 'Mechs';
      case BattleGroupKind.naves:
        return 'Naves';
    }
  }

  String get shortEs {
    switch (this) {
      case BattleGroupKind.soldados:
        return 'SOL';
      case BattleGroupKind.arqueros:
        return 'ARQ';
      case BattleGroupKind.vehiculos:
        return 'ROV';
      case BattleGroupKind.mechs:
        return 'MEC';
      case BattleGroupKind.naves:
        return 'NAV';
    }
  }

  UnitKind get unitKind {
    switch (this) {
      case BattleGroupKind.soldados:
        return UnitKind.infantryFrog;
      case BattleGroupKind.arqueros:
        return UnitKind.infantryBee;
      case BattleGroupKind.vehiculos:
        return UnitKind.rover;
      case BattleGroupKind.mechs:
        return UnitKind.mech;
      case BattleGroupKind.naves:
        return UnitKind.shipCaza;
    }
  }

  TechKind? get requiredTech {
    switch (this) {
      case BattleGroupKind.soldados:
        return null;
      case BattleGroupKind.arqueros:
        return TechKind.combatArchers;
      case BattleGroupKind.vehiculos:
        return TechKind.combatVehicles;
      case BattleGroupKind.mechs:
        return TechKind.combatMechs;
      case BattleGroupKind.naves:
        return TechKind.shipConstruction;
    }
  }
}

extension BattleCommandLabel on BattleCommand {
  String get labelEs {
    switch (this) {
      case BattleCommand.cargar:
        return 'Cargar';
      case BattleCommand.mantener:
        return 'Mantener';
      case BattleCommand.retirar:
        return 'Retirar';
      case BattleCommand.fuegoConcentrado:
        return 'Fuego concentrado';
    }
  }
}
