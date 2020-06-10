state Waiting in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state WAITING");

    parent.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

    if (previous_state_name == 'SpawningCancelled') {
      parent.ticks_before_spawn = parent.ticks_before_spawn / 3;
    }

    this.startWaiting();
  }

  entry function startWaiting() {
    parent.AddTimer('randomEncounterTick', 1.0, true);
  }

  timer function randomEncounterTick(optional delta: float, optional id: Int32) {
    if (parent.ticks_before_spawn < 0) {
      parent.GotoState('Spawning');
    }

    parent.ticks_before_spawn -= 1;
  }

  function calculateRandomTicksBeforeSpawn(): int {
    if (parent.settings.customFrequency) {
      if (theGame.envMgr.IsNight()) {
        return RandRange(parent.settings.customNightMin, parent.settings.customNightMax);
      }

      return RandRange(parent.settings.customDayMin, parent.settings.customDayMax);
    }
    
    if (theGame.envMgr.IsNight()) {
      switch (parent.settings.chanceNight) {
        case 1:
          return RandRange(1400, 3200);
          break;
        
        case 2:
          return RandRange(800, 1600);
          break;

        case 3:
          return RandRange(500, 900);
          break;
      }

      return 99999;
    }

    switch (parent.settings.chanceDay) {
      case 1:
        return RandRange(1400, 3900);
        break;

      case 2:
        return RandRange(800, 1800);
        break;

      case 3:
        return RandRange(500, 1100);
        break;
    }

    return 99999;
  }
}
