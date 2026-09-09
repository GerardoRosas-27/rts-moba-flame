enum ResourceKind { mineral, gas }

enum BuildingKind {
  commandCenter,
  refinery,
  supplyDepot,
  barracks,
  outpost,
}

enum UnitKind { worker }

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
  refinery,
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
      case BuildingKind.refinery:
        return 'Refinería';
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
      case BuildingKind.refinery:
        return 'REF';
      case BuildingKind.supplyDepot:
        return 'DEP';
      case BuildingKind.barracks:
        return 'CUA';
      case BuildingKind.outpost:
        return 'PA';
    }
  }
}

extension UnitKindLabel on UnitKind {
  String get labelEs {
    switch (this) {
      case UnitKind.worker:
        return 'Obrero';
    }
  }
}
