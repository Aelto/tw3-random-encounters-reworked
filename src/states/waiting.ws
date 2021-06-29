
state Waiting in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state WAITING");

    parent.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

    if (previous_state_name == 'SpawningCancelled') {
      parent.ticks_before_spawn = parent.ticks_before_spawn / 3;
    }

    if (parent.rExtra.isPlayerInSettlement()) {
      parent.ticks_before_spawn = (int)(parent.ticks_before_spawn * parent.settings.settlement_delay_multiplier);
    }

    LogChannel('modRandomEncounters', "waiting " + parent.ticks_before_spawn + " ticks");

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
    if (theGame.envMgr.IsNight()) {
      return RandRange(parent.settings.customNightMin, parent.settings.customNightMax)
           + parent.settings.additional_delay_per_player_level;
    }

    return RandRange(parent.settings.customDayMin, parent.settings.customDayMax)
         + parent.settings.additional_delay_per_player_level;
  }
}
