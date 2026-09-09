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

enum TechKind {
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
        return 'Infantería Finn';
      case UnitKind.infantryBee:
        return 'Infantería Barbara';
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
        return 'FIN';
      case UnitKind.infantryBee:
        return 'BEE';
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
}

extension TechKindLabel on TechKind {
  String get labelEs {
    switch (this) {
      case TechKind.shipConstruction:
        return 'Construcción de naves';
    }
  }

  String get shortEs {
    switch (this) {
      case TechKind.shipConstruction:
        return 'NAV';
    }
  }
}
