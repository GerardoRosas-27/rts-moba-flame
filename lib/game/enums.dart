enum ResourceKind { mineral }

enum BuildingKind {
  commandCenter,
  solarPanel,
  supplyDepot,
  barracks,
  outpost,
}

enum UnitKind {
  worker,
  infantryFrog,
  infantryBee,
  rover,
  mech,
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
    }
  }

  bool get canHarvest => this == UnitKind.worker;
  bool get canBuild => this == UnitKind.worker;
}
